# frozen_string_literal: true

FactoryBot.define do
  factory :pricing_rule do
    association :product
    rule_type { 'bulk_purchase' }
    threshold_quantity { 3 }
    discount_price { 8.0 }
    discount_rate { 0.2 }
    active { true }

    trait :bogof do
      rule_type { 'bogof' }
      threshold_quantity { 2 }
    end

    trait :bulk_purchase do
      rule_type { 'bulk_purchase' }
      discount_price { 8.0 }
    end

    trait :volume_discount do
      rule_type { 'volume_discount' }
      discount_rate { 0.2 }
    end
  end
end
