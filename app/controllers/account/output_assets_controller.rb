# frozen_string_literal: true

module Account
  class OutputAssetsController < BaseController
    def show
      @asset = OutputAsset.find(params[:id])
      @url = account_output_asset_download_url(@asset)
    end

    def download
      @asset = OutputAsset.find(params[:id])
      send_file(@asset.attachment.path, x_sendfile: true,
                                        type: @asset.attachment.content_type,
                                        filename: @asset.attachment.original_filename)
    end
  end
end
