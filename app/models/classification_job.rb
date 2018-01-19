# frozen_string_literal: true

class ClassificationJob < ApplicationRecord
  belongs_to :classifier
  has_many :output_assets, dependent: :destroy
  delegate :name, to: :classifier, prefix: true
  default_scope { order(id: :desc) }

  def job_id
    "##{job_number}"
  end
end
