# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    before_action :authenticate
    skip_before_action :verify_authenticity_token

    private

    def authenticate
      return unless Rails.env.production?
      return if request.headers["X-Api-Key"] == Rails.application.secrets.api_password
      render json: { status: :unauthorized }
    end
  end
end
