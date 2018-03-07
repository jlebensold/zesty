# frozen_string_literal: true

module Account
  class LabelsController < BaseController
    before_action :fetch_classifier

    def index; end

    def create
      render json: { status: :ok, notice: "Record(s) has been created." }
    end

    def destroy
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
