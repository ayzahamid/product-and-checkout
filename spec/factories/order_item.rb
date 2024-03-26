# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    quantity { 1 }
    price_at_purchase_time { 10.0 }
    price_after_discount { 9.0 }

    association :order
    association :product
  end
end
