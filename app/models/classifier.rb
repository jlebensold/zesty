# frozen_string_literal: true

class Classifier < ApplicationRecord
  belongs_to :organization
  meta_attr :labels
  has_many :input_assets, dependent: :destroy
  has_many :classification_jobs, dependent: :destroy
  has_many :output_assets, dependent: :destroy

  def last_run_at
    classification_jobs.first&.created_at
  end

  def asset_labels
    labels.split("\r\n")
  end
end
