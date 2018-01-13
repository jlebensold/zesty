# frozen_string_literal: true

class ClassifyJob < ApplicationJob
  require 'zip'
  queue_as :default

  FILES_TO_COLLECT = {
    mlmodel: "graph.mlmodel",
    tensorflow: "graph.pb",
    labels: "labels.txt",
    optimized_tensorflow: "optimized_graph.pb"
  }

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
    logger.info "Starting Job ##{classification_job_id}"
    Dir.mktmpdir do |dir|
      prepare_job_folder(dir, classification_job_id)
      run_crumbs(dir)
      collect_assets(classification_job_id)
    end
  end

  def prepare_job_folder(dir, id)
    package = RestClient::Request.execute(method: :get, url: "#{url}/input_job_assets/#{id}",
                                headers: { 'X-Api-Key' => api_key })
    zipfile = Tempfile.new("package.zip", "wb")
    zipfile.write(package.body)

    Zip::File.open(zipfile) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(dir, f.name)
        FileUtils.mkdir_p(File.dirname(fpath))
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end
  end



  def collect_assets(job_id)
    FILES_TO_COLLECT.each do |label, filename|
      file_path = File.join(path_to_crumbs, "output", filename)
      if !File.exists?(file_path)
        logger.info "Asset #{file_path} missing. returning..."
      end
      send_file(file_path, label, job_id)
      File.unlink(file_path)
    end
  end

  def send_file(path, label, id)
    RestClient::Request.execute(method: :post, url: "#{url}/output_assets",
                                headers: { 'X-Api-Key' => api_key },
                                payload: {
                                  label: label,
                                  file: File.new(path),
                                  id: id
                                })
  end

  def run_crumbs(dir)
    logger.info "Running crumbs (#{path_to_crumbs}) -  #{dir}"
    system(File.join(path_to_crumbs, "run.sh"), path_to_crumbs, dir)
  end
end
