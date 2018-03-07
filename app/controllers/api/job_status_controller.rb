# frozen_string_literal: true

module Api
  class JobStatusController < BaseController
    def update
      job = ClassificationJob.find(params[:id])
      job.update_attributes(status: params[:status])
      render json: { success: :ok }
    end
  end
end
