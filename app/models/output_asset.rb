# frozen_string_literal: true

class OutputAsset < ApplicationRecord
  belongs_to :classifier
  belongs_to :classification_job
  has_attached_file :attachment, path: ":rails_root/assets/output/:id/:filename"
  do_not_validate_attachment_file_type :attachment
  default_scope { order(id: :desc) }

  delegate :job_id, to: :classification_job, prefix: false

  def icon
    return "fab fa-android" if label == "optimized_tensorflow"
    return "fab fa-google" if label == "tensorflow"
    return "fas fa-mobile" if label == "mlmodel"
    return "fas fa-file-alt" if label == "labels"
  end

  def name
    return "graph.pb (optimized)" if label == "optimized_tensorflow"
    return "graph.mlmodel" if label == "mlmodel"
    return "graph.pb" if label == "tensorflow"
    return "labels.txt" if label == "labels"
  end
end
