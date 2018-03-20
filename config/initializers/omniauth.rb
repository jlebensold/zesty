# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  require "openid/store/filesystem"
  # TODO: implement github support
  #  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end
