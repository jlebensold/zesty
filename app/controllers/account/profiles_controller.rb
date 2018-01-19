# frozen_string_literal: true

module Account
  class ProfilesController < ApplicationController
    before_action :authenticate_user!
    def index
    end
  end
end
