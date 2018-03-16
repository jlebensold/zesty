# frozen_string_literal: true

module Api
  class AssetsController < BaseController
    def show
      StorageManager.new.send_file(InputAsset.find(params[:id]), self) if params[:type] == "input"
      StorageManager.new.send_file(OutputAsset.find(params[:id]), self) if params[:type] == "output"
    end
  end
end
