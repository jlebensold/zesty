# frozen_string_literal: true

module Api
  class OutputAssetsController < BaseController
    def create
      job = ClassificationJob.find(params[:id])
      job.output_assets.create!(attachment: params[:file], label: params[:label],
                                classifier: job.classifier)
      job.update_attributes(status: :finishing)
      render json: { success: :ok }
    end
  end
end
