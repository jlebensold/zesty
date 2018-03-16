# frozen_string_literal: true

class ClassificationJob < ApplicationRecord
  belongs_to :classifier
  has_many :output_assets, dependent: :destroy
  delegate :name, to: :classifier, prefix: true
  default_scope { order(id: :desc) }

  def clock_time
    return "-" if started_at.nil?
    time_diff = status == "completed" ? started_at - updated_at : started_at - Time.zone.now
    if Time.at(time_diff.to_i.abs).utc.strftime("%H") == "00"
      return Time.at(time_diff.to_i.abs).utc.strftime "%M:%S"
    end
    Time.at(time_diff.to_i.abs).utc.strftime "%H:%M:%S"
  end

  def store_artifact!(file, label)
    return store_log_artifact(file) if label == "log"
    create_output_asset!(file, label)
  end

  def store_log_artifact(file)
    log = output_assets.find_by(label: "log")
    if log.blank?
      create_output_asset!(file, "log")
    else
      log.update_attributes(attachment: file)
    end
  end

  def create_output_asset!(file, label)
    output_assets.create!(attachment: file, label: label, classifier: classifier)
  end

  def job_id
    "##{job_number}"
  end

  def log_as_text
    log_asset&.read_as_text
  end

  def log_asset
    output_assets.find_by(label: :log)
  end

  def as_worker_manifest
    classifier.input_assets.map do |asset|
      {
        id: asset.id,
        url: asset.public_url,
        labels: [asset.label.strip],
        filename: "#{Digest::SHA1.hexdigest("#{asset.label}#{asset.id}")}_#{asset.attachment.original_filename}"
      }
    end
  end
end
