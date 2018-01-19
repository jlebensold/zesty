# frozen_string_literal: true

module Account
  class DashboardController < BaseController
    def index
      @classifiers = Classifier.where(organization: current_user.organization)
      @recent_assets = OutputAsset.joins(:classifier)
        .where(classifiers: { organization: current_user.organization }).limit(5)

    end
  end
end
