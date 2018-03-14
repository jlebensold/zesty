# frozen_string_literal: true

class OutputAsset < ApplicationRecord
  belongs_to :classifier
  belongs_to :classification_job
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
  default_scope { order(id: :desc) }

  delegate :job_id, to: :classification_job, prefix: false

  def read_as_text
    IO.readlines(attachment.path).reverse.join
  end

  def icon
    return "fab fa-android" if label == "optimized_tensorflow"
    return "fab fa-google" if label == "tensorflow"
    return "fas fa-mobile" if label == "mlmodel"
    return "fas fa-file-alt" if label == "labels"
    return "fas fa-file-alt" if label == "log"
  end

  def name
    return "graph.pb (optimized)" if label == "optimized_tensorflow"
    return "graph.mlmodel" if label == "mlmodel"
    return "graph.pb" if label == "tensorflow"
    return "labels.txt" if label == "labels"
    return "build.log" if label == "log"
  end
end
