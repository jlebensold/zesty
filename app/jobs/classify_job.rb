# frozen_string_literal: true
require 'open3'

class ClassifyJob < ApplicationJob
  require "zip"
  queue_as :default

  FILES_TO_COLLECT = {
    mlmodel: "graph.mlmodel",
    tensorflow: "graph.pb",
    labels: "labels.txt",
    optimized_tensorflow: "optimized_graph.pb"
  }.freeze

  def self.total_file_count
    # log + FILES_TO_COLLECT
    FILES_TO_COLLECT.count + 1
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
    @job_logger.info "Starting Job ##{classification_job_id}"
    @job_id = classification_job_id
    update_server_status(:started)
    update_log_on_server
    Dir.mktmpdir do |dir|
      update_server_status(:preparing)
      prepare_job_folder(dir)
      run_crumbs(dir)
      collect_assets
    end
    update_log_on_server
    update_server_status(:completed)
  end

  def prepare_job_folder(dir)
    @job_logger.info "Prepare job folder: #{dir} for #{@job_id}"
    package = RestClient::Request.execute(method: :get, url: "#{url}/input_job_assets/#{@job_id}",
                                          headers: { "X-Api-Key" => api_key })
    zipfile = Tempfile.new("package.zip")
    File.open(zipfile, "wb") do |file|
      file.write(package.body)
    end

    @job_logger.tagged("File Preparation") do
      Zip::File.open(zipfile) do |zip_file|
        zip_file.each do |f|
          fpath = File.join(dir, f.name)
          FileUtils.mkdir_p(File.dirname(fpath))
          @job_logger.info "Extracting: #{f}"
          zip_file.extract(f, fpath) unless File.exist?(fpath)
        end
      end
    end
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

  def run_crumbs(dir)
    @job_logger.info "Running training (#{path_to_crumbs}) -  #{dir}"
    cmd_args = [File.join(path_to_crumbs, "run.sh"), path_to_crumbs, dir, Rails.env]
    update_server_status(:training)
    count = 0
    @job_logger.tagged("Training") do
      Open3.popen2e(cmd_args.join(" ")) do |stdin, stdout|
        stdout.each_line do |line|
          count = count + 1
          @job_logger.info line.gsub("\n","")

          update_log_on_server if count % 100 == 0
        end
      end
    end
  end
end
