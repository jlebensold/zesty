# frozen_string_literal: true

class Account::OutputAssetsController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_model, only: %i[edit show update destroy]

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

  private


  def fetch_model
  end
end
