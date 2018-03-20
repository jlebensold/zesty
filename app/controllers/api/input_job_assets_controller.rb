# frozen_string_literal: true

module Api
  class InputJobAssetsController < BaseController
    def show
      job = ClassificationJob.find(params[:id])
      job.update(status: :started)
      render json: job.as_worker_manifest
    end
  end
end
