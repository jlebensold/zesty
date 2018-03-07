# frozen_string_literal: true

module Account
  class JobsController < BaseController
    before_action :fetch_classifier

    def index; end

    def show
      @job = ClassificationJob.find(params[:id])
      @classifier = @job.classifier
      @log = @job.log_as_text
    end

    def create
      job = ClassificationJob.create!(classifier: @classifier, status: :queued,
                                      job_number: (@classifier.classification_jobs.count + 1))
      ClassifyJob.perform_later job.id
      redirect_to account_classifier_path(@classifier), notice: "Job Started."
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
