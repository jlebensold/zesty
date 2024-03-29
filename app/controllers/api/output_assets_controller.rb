# frozen_string_literal: true

module Api
  class OutputAssetsController < BaseController
    def create
      job = ClassificationJob.find(params[:id])
      job.store_artifact!(params[:file], params[:label])
      render json: { success: :ok }
    end
  end
end
