module Account
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :fetch_sidebar_models

    def fetch_sidebar_models
      @classification_jobs = ClassificationJob.joins(:classifier)
        .where(classifiers: { organization: current_user.organization })
    end
  end
end
