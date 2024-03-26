# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    status { 'pending' }
    total_price { 9.0 }
  end
end
