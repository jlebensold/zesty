# frozen_string_literal: true

class InputAsset < ApplicationRecord
  belongs_to :classifier
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
end
