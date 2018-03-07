# frozen_string_literal: true

module Account
  class ProfilesController < BaseController
    before_action :authenticate_user!
    def index
    end
  end
end
