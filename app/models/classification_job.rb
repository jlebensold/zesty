# frozen_string_literal: true

class ClassificationJob < ApplicationRecord
  belongs_to :classifier
  has_many :output_assets, dependent: :destroy
  default_scope { order(id: :desc) }
end
