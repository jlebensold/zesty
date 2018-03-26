# frozen_string_literal: true

class Classifier < ApplicationRecord
  belongs_to :organization
  meta_attr :labels
  has_many :input_assets, dependent: :destroy
  has_many :classification_jobs, dependent: :destroy
  has_many :output_assets, dependent: :destroy

  after_validation :cleanup_labels

  def cleanup_labels
    self.labels = asset_labels.map do |label|
      label.strip
           .tr(" ", "_")
           .gsub(/\W/, "")
           .downcase
           .truncate(30, omission: "")
    end.uniq.compact.join("\r\n")
  end

  def grouped_asset_labels(label)
    InputAsset.select(:label, :attachment_file_name)
              .where(classifier_id: id)
              .where(label: label).group(:label, :attachment_file_name)
  end

  def sample_count
    input_assets.count
  end

  def calculate_bytes
    input_assets.map(&:attachment_file_size).sum
  end

  def active_asset_labels
    assets = InputAsset.select(:label).where(classifier_id: id).group(:label).count
    asset_labels.map do |label|
      [label, assets.find { |l| l[0] == label }.try(:[], 1) || 0]
    end
  end

  def inactive_asset_labels
    InputAsset.select(:label)
              .where(classifier_id: id)
              .where.not(label: asset_labels)
              .group(:label).count
  end

  def model_type
    "image.MobileNet_v1_1.0_224"
  end

  def last_run_at
    last_job&.created_at
  end

  def last_run_job_id
    last_job&.job_id
  end

  def last_job
    classification_jobs.first
  end

  def asset_labels
    labels.gsub("\r","").split("\n")
  end
end
