# frozen_string_literal: true

class ClassifyJob < ApplicationJob
  queue_as :default

  def path_to_crumbs
    Rails.application.secrets.path_to_crumbs
  end

  def perform(classification_job_id)
    logger.info "Starting Job ##{classification_job_id}"
    classification_job = ClassificationJob.find(classification_job_id)
    classification_job.update_attributes(status: "started")
    Dir.mktmpdir do |dir|
      prepare_job_folder(dir, classification_job.classifier)
      classification_job.update_attributes(status: "s1_classifying")
      run_crumbs(dir)
      classification_job.update_attributes(status: "s2_classifier_created")
      collect_assets(classification_job)
    end
  end

  def collect_assets(job)
    ml_model = File.join(path_to_crumbs, "output", "graph.mlmodel")
    tf_model = File.join(path_to_crumbs, "output", "graph.pb")
    if !File.exists?(ml_model) || !File.exists?(tf_model)
      logger.info "Assets don't exist. returning..."
      job.update_attributes(status: "failed")
      return
    end
    job.output_assets.create!(attachment: File.new(ml_model), label: "mlmodel",
                              classifier: job.classifier)
    job.output_assets.create!(attachment: File.new(tf_model), label: "tensorflow graph",
                              classifier: job.classifier)
    job.update_attributes(status: "completed")
  end

  def run_crumbs(dir)
    logger.info "Running crumbs (#{path_to_crumbs}) -  #{dir}"
    system(File.join(path_to_crumbs, "run.sh"), path_to_crumbs, dir)
  end

  def prepare_job_folder(dir, classifier)
    classifier.asset_labels.each do |label|
      label_path = File.join(dir, label)
      Dir.mkdir(label_path) unless File.exist? label_path
      classifier.input_assets.where(label: label).each do |asset|
        copy_path = File.join(label_path, asset.attachment.original_filename)
        logger.info "Saving #{copy_path}"
        asset.attachment.copy_to_local_file(:original, copy_path)
      end
    end
  end
end
