# frozen_string_literal: true

module Account
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    def index; end
  end
end
