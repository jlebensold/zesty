# frozen_string_literal: true

class StorageManager
  attr_accessor :backend

  def initialize
    @backend = Rails.env.production? ? GoogleBackend.new : FileBackend.new
  end

  def copy_to_local_file(asset, copy_path)
    @backend.copy_to_local_file(asset, copy_path)
  end

  def send_file(asset, controller)
    @backend.send_file(asset, controller)
  end

  def read_as_text(asset)
    @backend.read_as_text(asset)
  end

  def public_url(asset, type)
    @backend.public_url(asset, type)
  end

  class GoogleBackend
    def send_file(asset, controller)
      controller.redirect_to public_url(asset), x_sendfile: true
    end

    def copy_to_local_file(asset, copy_path)
      file = CloudStorage.fetch_file(asset.attachment.path(:original))
      file.download copy_path, verify: :all
    end

    def read_as_text(asset)
      file = CloudStorage.fetch_file(asset.attachment.path(:original))
      downloaded = file.download
      downloaded.rewind
      lines = downloaded.read.split("\n")
      lines.reverse.join("\n")
    end

    def public_url(asset, _type = nil)
      file = CloudStorage.fetch_file(asset.attachment.path(:original))
      file.signed_url
    end
  end

  class FileBackend
    attr_accessor :api_url

    def initialize
      @api_url = Rails.application.secrets.artifact_output_path
    end

    def copy_to_local_file(asset, copy_path)
      asset.attachment.copy_to_local_file(:original, copy_path)
    end

    def send_file(asset, controller)
      controller.send_file(asset.attachment.path, x_sendfile: true,
                                                  type: asset.attachment.content_type,
                                                  filename: asset.attachment.original_filename)
    end

    def public_url(asset, asset_type)
      "#{api_url}/asset/#{asset.id}?type=#{asset_type}"
    end

    def read_as_text(asset)
      IO.readlines(asset.attachment.path).reverse.join
    end
  end
end
