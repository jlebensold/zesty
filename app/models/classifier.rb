# frozen_string_literal: true

class Classifier < ApplicationRecord
  belongs_to :organization
  meta_attr :labels
  has_many :input_assets, dependent: true
  has_many :classification_jobs, dependent: true
  has_many :output_assets, dependent: true
  def asset_labels
    labels.split("\r\n")
  end
end
