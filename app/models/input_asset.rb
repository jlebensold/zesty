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
      return storage.bucket ENV["GCS_BUCKET_NAME"]
    else
      attachment.copy_to_local_file(:original, copy_path)
    end
  end
end
