# frozen_string_literal: true

module Account
  class InputAssetsController < BaseController
    before_action :fetch_classifier

    def index; end

    def create
      params[:file].each do |_key, file|
        @classifier.input_assets.create(label: params[:label], attachment: file)
      end
      render json: { status: :ok, notice: "Record(s) has been created." }
    end

    def destroy
      @input_asset = InputAsset.find(params[:id])
      @input_asset.destroy!
      render json: { status: :ok, notice: "Record(s) has been destroyed." }
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
