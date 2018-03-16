# frozen_string_literal: true

require "google/cloud/storage"

class InputAsset < ApplicationRecord
  belongs_to :classifier
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment

  def public_url
    StorageManager.new.public_url(self, "input")
  end

  def copy_to_local_file(copy_path)
    StorageManager.new.copy_to_local_file(self, copy_path)
  rescue StandardError => error
    p error
    return nil
  end
end
