# frozen_string_literal: true

module Api
  class AssetsController < BaseController
    def show
      send_input_asset if params[:type] == "input"
      send_output_asset if params[:type] == "output"
    end

    def send_input_asset
      StorageManager.new.send_file(InputAsset.find(params[:id]), self)
    end

    def send_output_asset
      StorageManager.new.send_file(OutputAsset.find(params[:id]), self)
    end
  end
end
