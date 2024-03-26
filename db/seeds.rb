# frozen_string_literal: true

green_tea = Product.create!(code: 'GR1', name: 'Green Tea', price: 3.11)
strawberry = Product.create!(code: 'SR1', name: 'Strawberries', price: 5.00)
coffee = Product.create!(code: 'CF1', name: 'Coffee', price: 11.23)

green_tea.pricing_rules.create!(rule_type: 'bogof', threshold_quantity: 3)
strawberry.pricing_rules.create!(rule_type: 'bulk_purchase', threshold_quantity: 3, discount_price: 4.50)
coffee.pricing_rules.create!(rule_type: 'volume_discount', threshold_quantity: 3, discount_rate: 0.6)
