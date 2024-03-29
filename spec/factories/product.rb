# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:code) { |n| "CODE#{n}" }
    name { 'Test Product' }
    price { 10.0 }
  end
end
