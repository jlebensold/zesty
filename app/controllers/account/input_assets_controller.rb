# frozen_string_literal: true

module Account
  class InputAssetsController < ApplicationController
    before_action :authenticate_user!
    before_action :fetch_classifier

    def index; end

    def create
      record_params[:attachments].each do |label|
        record_params[:attachments][label].each do |attachment|
          @classifier.input_assets.create(label: label, attachment: attachment)
        end
      end
      redirect_to account_classifier_input_assets_path(@classifier),
                  notice: "Record(s) has been created."
    end

    def destroy
      @input_asset = InputAsset.find(params[:id])
      @input_asset.destroy!
      redirect_to account_classifier_input_assets_path(@classifier),
                  notice: "Record(s) has been destroyed."
    end

    private

    def record_params
      params.require(:input_assets).permit(attachments: {})
    end

    def fetch_classifier
      @classifier = Classifier.find(params[:classifier_id])
    end
  end
end
