# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "account/sessions",
                                    registrations: "account/registrations",
                                    confirmations: "account/confirmations",
                                    invitations: "account/invitations",
                                    passwords: "account/passwords" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  namespace :api do
    resources :output_assets
    resources :input_job_assets
    resources :assets
    resources :job_status
    mount_devise_token_auth_for "User", at: :auth, skip: [:omniauth_callbacks], controllers: {
      sessions: "api/sessions"
    }
  end

  namespace :account do
    get "/dashboard", to: "dashboard#index"
    resources :output_assets
    resources :profiles
    get "/output_assets/:id/download", to: "output_assets#download", as: :output_asset_download
    resources :classifiers do
      resources :input_assets
      resources :labels
      resources :jobs
    end
  end
end
# rubocop:enable Metrics/BlockLength
