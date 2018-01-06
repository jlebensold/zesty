# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "account/sessions",
                                    registrations: "account/registrations",
                                    confirmations: "account/confirmations",
                                    invitations: "account/invitations",
                                    passwords: "account/passwords" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  namespace :account do
    get "/dashboard", to: "dashboard#index"
    resources :classifiers
  end
end
