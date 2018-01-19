# frozen_string_literal: true

module Api
  class OutputAssetsController < BaseController
    def create
      job = ClassificationJob.find(params[:id])
      job.output_assets.create!(attachment: params[:file], label: params[:label],
                                classifier: job.classifier)
      if job.output_assets.count == ClassifyJob::FILES_TO_COLLECT.count
        job.update_attributes(status: :completed)
      else
        job.update_attributes(status: :collecting_assets)
      end
      render json: { success: :ok }
    end
  end
end
