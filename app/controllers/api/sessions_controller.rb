# frozen_string_literal: true

module Api
  class SessionsController < DeviseTokenAuth::SessionsController
    skip_before_action :verify_authenticity_token
  end
end
