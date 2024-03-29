# frozen_string_literal: true

Rails.application.routes.draw do
  root 'products#index'

  resources :carts, only: [:index] do
    collection do
      post :reset
      post :add
    end
  end

  resources :products, only: [:index] do
    resource :pricing_rule, only: %i[edit create update]
  end
end
