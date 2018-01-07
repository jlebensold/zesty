# frozen_string_literal: true

class Classifier < ApplicationRecord
  belongs_to :organization
  meta_attr :labels
  has_many :input_assets
  has_many :classification_jobs
  has_many :output_assets
  def asset_labels
    labels.split("\r\n")
  end
end
