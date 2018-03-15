# frozen_string_literal: true

module Account
  class OutputAssetsController < BaseController
    def show
      @asset = OutputAsset.find(params[:id])
      @url = account_output_asset_download_url(@asset)
    end

    def download
      @asset = OutputAsset.find(params[:id])
      file = CloudStorage.fetch_file(@asset.attachment.path(:original))
      redirect_to file.signed_url, x_sendfile: true
    end
  end
end
