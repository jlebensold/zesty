# frozen_string_literal: true

class Classifier < ApplicationRecord
  belongs_to :organization
  meta_attr :labels
  has_many :input_assets, dependent: :destroy
  has_many :classification_jobs, dependent: :destroy
  has_many :output_assets, dependent: :destroy

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
    labels.split("\r\n")
  end
end
