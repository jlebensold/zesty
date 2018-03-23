# frozen_string_literal: true

module Account
  class OutputAssetsController < BaseController
    def show
    end

    def download
      @asset = OutputAsset.find(params[:id])
      StorageManager.new.send_file(@asset, self)
    end
  end
end
