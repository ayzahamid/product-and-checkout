# frozen_string_literal: true

Rails.application.routes.draw do
  root 'products#index'
  resources :products, only: [:index]

  post 'carts/add_to_cart', as: 'add_to_cart'
  get 'cart', to: 'carts#show', as: 'cart'
end
