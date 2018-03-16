# frozen_string_literal: true

module Account
  class OutputAssetsController < BaseController
    def show
      @asset = OutputAsset.find(params[:id])
      @url = account_output_asset_download_url(@asset)
    end

    def download
      @asset = OutputAsset.find(params[:id])
      StorageManager.new.send_file(@asset, self)
    end
  end
end
