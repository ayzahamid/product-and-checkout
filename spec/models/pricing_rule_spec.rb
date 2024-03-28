# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PricingRule, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      product = Product.create(code: '001', name: 'Test Product', price: 10.0)
      pricing_rule = product.build_pricing_rule(
        rule_type: 'bulk_purchase',
        threshold_quantity: 3,
        discount_price: 5.0,
        active: true
      )
      expect(pricing_rule).to be_valid
    end

    it 'is not valid without a rule type' do
      pricing_rule = PricingRule.new(rule_type: nil)
      expect(pricing_rule).not_to be_valid
      expect(pricing_rule.errors[:rule_type]).to include("can't be blank")
    end

    it 'is not valid without a threshold quantity' do
      pricing_rule = PricingRule.new(threshold_quantity: nil)
      expect(pricing_rule).not_to be_valid
      expect(pricing_rule.errors[:threshold_quantity]).to include("can't be blank")
    end

    context 'with bulk_purchase rule_type' do
      it 'requires a discount_price' do
        pricing_rule = PricingRule.new(rule_type: 'bulk_purchase', discount_price: nil)
        expect(pricing_rule).not_to be_valid
        expect(pricing_rule.errors[:discount_price]).to include("can't be blank")
      end
    end

    context 'with volume_discount rule_type' do
      it 'requires a discount_rate' do
        pricing_rule = PricingRule.new(rule_type: 'volume_discount', discount_rate: nil)
        expect(pricing_rule).not_to be_valid
        expect(pricing_rule.errors[:discount_rate]).to include("can't be blank")
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:product) }
  end
end
