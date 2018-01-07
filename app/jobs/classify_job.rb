class ClassifyJob < ApplicationJob
  queue_as :default

  PATH_TO_CRUMBS = "/Users/jon/Projects/crumbs"

  def perform(classification_job_id)
    p "Starting Job ##{classification_job_id}"
    classification_job = ClassificationJob.find(classification_job_id)
    classification_job.update_attributes(status: "started")
    Dir.mktmpdir do |_dir|
      dir = "/Users/jon/Desktop/test"
      prepare_job_folder(dir, classification_job.classifier)
      classification_job.update_attributes(status: "s1_classifying")
      run_crumbs(dir)
      classification_job.update_attributes(status: "s2_classifier_created")
      collect_assets(classification_job)
      classification_job.update_attributes(status: "completed")
    end
  end

  def collect_assets(job)
    ml_model = File.join(PATH_TO_CRUMBS, "output", "graph.mlmodel")
    job.output_assets.create!(attachment: File.new(ml_model), label: "mlmodel", classifier: job.classifier)
    tf_model = File.join(PATH_TO_CRUMBS, "output", "graph.pb")
    job.output_assets.create!(attachment: File.new(tf_model), label: "tensorflow graph", classifier: job.classifier)
  end

  def run_crumbs(dir)
    p "Running crumbs on #{dir}"
    system(File.join(PATH_TO_CRUMBS, "run.sh"), PATH_TO_CRUMBS, dir)
  end

  def prepare_job_folder(dir, classifier)
    classifier.asset_labels.each do |label|
      label_path = File.join(dir, label)
      Dir.mkdir(label_path) unless File.exists? label_path
      classifier.input_assets.where(label: label).each do |asset|
        copy_path = File.join(label_path, asset.attachment.original_filename)
        asset.attachment.copy_to_local_file(:original, copy_path )
      end
    end
  end
end
