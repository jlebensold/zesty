# frozen_string_literal: true

require "google/cloud/storage"

class InputAsset < ApplicationRecord
  belongs_to :classifier
  has_attached_file :attachment,
                    styles: { thumb: ["90x90#", :jpg] }
  do_not_validate_attachment_file_type :attachment

  def public_url
    StorageManager.new.public_url(self, "input")
  end

  def thumbnail_url
    StorageManager.new.thumbnail_url(self)
  end

  def copy_to_local_file(copy_path)
    StorageManager.new.copy_to_local_file(self, copy_path)
  rescue StandardError => error
    Rails.logger.info error
  end
end
