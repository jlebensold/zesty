# frozen_string_literal: true

module Api
  class JobStatusController < BaseController
    def update
      job = ClassificationJob.find(params[:id])
      update_params = { status: params[:status] }
      update_params[:started_at] = Time.zone.now if params[:status] == "started"
      job.update(update_params)
      render json: { success: :ok }
    end
  end
end
