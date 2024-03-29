# frozen_string_literal: true

require "open3"
require "socket"

class ClassifyJob < ApplicationJob
  queue_as :default

  FILES_TO_COLLECT = {
    mlmodel: "graph.mlmodel",
    tensorflow: "graph.pb",
    labels: "labels.txt",
    optimized_tensorflow: "optimized_graph.pb" # this is taking too long
  }.freeze

  def self.total_file_count
    # log + FILES_TO_COLLECT
    FILES_TO_COLLECT.count + 1
  end

  rescue_from(StandardError) do |exception|
    Rails.logger.error "[#{self.class.name}] Job failed: #{exception}"
    update_server_status(:failed)
    update_log_on_server
  end

  def path_to_crumbs
    Rails.application.secrets.path_to_crumbs
  end

  def url
    Rails.application.secrets.artifact_output_path
  end

  def api_key
    Rails.application.secrets.api_password
  end

  def perform(classification_job_id)
    @job_logger.info "Starting Job ##{classification_job_id} on #{Socket.gethostname}"
    @job_id = classification_job_id
    update_server_status :started
    update_log_on_server
    Dir.mktmpdir do |dir|
      perform_training(dir)
    end
    update_log_on_server
    update_server_status :completed
  end

  def perform_training(dir)
    update_server_status :preparing
    prepare_job_folder(dir)
    run_crumbs(dir)
    collect_assets
  end

  def fetch_job_manifest
    json = RestClient::Request.execute(method: :get, url: "#{url}/input_job_assets/#{@job_id}",
                                       headers: { "X-Api-Key" => api_key })
    JSON.parse(json.body)
  end

  def prepare_job_folder(dir)
    @job_logger.info "Prepare job folder: #{dir} for #{@job_id}"
    manifest = fetch_job_manifest
    manifest.each do |input_asset|
      params = input_asset.deep_symbolize_keys
      params[:labels].each do |label|
        @job_logger.info "Fetching: #{params[:id]}"
        fetch_asset(params[:url], params[:filename], File.join(dir, label))
      end
    end
  end

  def fetch_asset(asset_url, filename, path)
    response = RestClient::Request.execute(method: :get, url: asset_url,
                                           headers: { "X-Api-Key" => api_key })
    FileUtils.mkdir_p(path)
    file = File.new("#{path}/#{filename}", "wb")
    file << response.body
    file.close
  end

  def collect_assets
    update_server_status(:collecting)
    FILES_TO_COLLECT.each do |label, filename|
      file_path = File.join(path_to_crumbs, "output", filename)
      @job_logger.info "Asset #{file_path} missing. returning..." unless File.exist?(file_path)
      send_file(file_path, label)
      File.unlink(file_path)
    end
  end

  def update_log_on_server
    send_file(@logger_tempfile.path, "log")
  end

  def update_server_status(status)
    RestClient::Request.execute(method: :put, url: "#{url}/job_status/#{@job_id}",
                                headers: { "X-Api-Key" => api_key },
                                payload: {
                                  status: status,
                                  id: @job_id
                                })
  end

  def send_file(path, label)
    logger.info "Sending file: #{path} - #{label} for #{@job_id}"
    @job_logger.tagged("Collecting") do
      RestClient::Request.execute(method: :post, url: "#{url}/output_assets",
                                  headers: { "X-Api-Key" => api_key },
                                  payload: {
                                    label: label,
                                    file: File.new(path),
                                    id: @job_id
                                  })
    end
  end

  def cmd_with_args(temp_dir)
    [File.join(path_to_crumbs, "run.sh"), path_to_crumbs, temp_dir, Rails.env].join(" ")
  end

  def run_crumbs(dir)
    @job_logger.info "Running training (#{path_to_crumbs}) -  #{dir}"
    update_server_status(:training)
    line_count = 0
    @job_logger.tagged("Training") do
      Open3.popen2e(cmd_with_args(dir)) do |_stdin, stdout|
        line_count += 1
        process_stdout(stdout, line_count)
      end
    end
  end

  def process_stdout(stdout, line_count)
    stdout.each_line do |line|
      @job_logger.info line.delete("\n")
      update_log_on_server if (line_count % 50).zero?
    end
  end
end
