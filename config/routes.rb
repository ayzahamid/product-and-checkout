# frozen_string_literal: true

Rails.application.routes.draw do
  root 'products#index'
  resources :products, only: [:index]

  resources :carts, only: [:index] do
    collection do
      post :reset
      post :add
    end
  end
end
