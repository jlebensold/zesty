# frozen_string_literal: true
require "google/cloud/storage"

class InputAsset < ApplicationRecord
  belongs_to :classifier
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment

  def copy_to_local_file(copy_path)
    if Rails.env.production?
      storage = Google::Cloud::Storage.new(
        project_id: ENV["GCS_PROJECT"],
        credentials: ENV["GCS_KEYFILE"]
      )
      bucket = storage.bucket ENV["GCS_BUCKET_NAME"]
      file = bucket.file(attachment.path(:original))
      file.download copy_path
    else
      attachment.copy_to_local_file(:original, copy_path)
    end
  end
end
