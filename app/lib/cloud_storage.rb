# frozen_string_literal: true

class CloudStorage
  def self.fetch_file(path)
    storage = Google::Cloud::Storage.new(
      project_id: ENV["GCS_PROJECT"],
      credentials: ENV["GCS_KEYFILE"]
    )
    bucket = storage.bucket ENV["GCS_BUCKET_NAME"]
    bucket.file path
  end
end
