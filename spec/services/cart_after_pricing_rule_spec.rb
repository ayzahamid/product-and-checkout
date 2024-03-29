# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartAfterPricingRule do
  let(:product) { create(:product, code: 'PRD001', price: 10.0) }
  let(:cart_data) { {} }
  let(:service) { described_class.new(cart_data, product.code, quantity) }

  describe 'Bulk Purchase Rule' do
    before do
      create(:pricing_rule, :bulk_purchase, product: product, discount_price: 8.0, threshold_quantity: 3)
    end

    context 'when add products to empty cart' do
      let(:quantity) { 5 }

      it 'applies bulk purchase discount correctly' do
        service.apply_pricing_rule

        expect(cart_data[product.code][:total_payable]).to eq(40.0)
      end
    end

    context 'when updates cart to add products' do
      let(:quantity) { 4 }
      let(:cart_data) { { product.code => { quantity: 1, price_at_purchase_time: 10.0 } } }

      it 'applies bulk discount correctly when threshold is reached' do
        service.apply_pricing_rule

        expect(cart_data[product.code][:total_payable]).to eq(40.0)
      end
    end
  end

  describe 'Volume Discount Rule' do
    before do
      create(:pricing_rule, :volume_discount, product: product, discount_rate: 0.2, threshold_quantity: 3)
    end

    context 'when add products to empty cart' do
      let(:quantity) { 5 }

      it 'applies volume discount correctly' do
        service.apply_pricing_rule
        total_price = 50.0
        expected_discount = total_price * 0.2

        expect(cart_data[product.code][:total_discount]).to eq(expected_discount)
        expect(cart_data[product.code][:total_payable]).to eq(total_price - expected_discount)
      end
    end

    context 'when updates cart to add products' do
      let(:quantity) { 2 }
      let(:cart_data) { { product.code => { quantity: 1, price_at_purchase_time: 10.0 } } }

      it 'applies volume discount correctly when threshold is reached' do
        service.apply_pricing_rule
        cart_item = cart_data[product.code]

        expect(cart_item[:quantity]).to eq(3)
        expect(cart_item[:price_at_purchase_time]).to eq(10.0)
        expect(cart_item[:total_payable]).to eq(24.0)
        expect(cart_item[:total_discount]).to eq(6.0)
      end
    end
  end

  describe 'BOGOF Rule' do
    before do
      create(:pricing_rule, :bogof, product: product, threshold_quantity: 3)
    end

    context 'when add products to empty cart' do
      let(:quantity) { 6 }

      it 'applies BOGOF rule correctly with threshold limit' do
        service.apply_pricing_rule

        expect(cart_data[product.code][:total_items]).to eq(9)
        expect(cart_data[product.code][:free_items]).to eq(3)
        expect(cart_data[product.code][:total_payable]).to eq(60.0)
      end
    end

    context 'when add products to empty cart' do
      let(:quantity) { 2 }
      let(:cart_data) { { product.code => { quantity: 2, price_at_purchase_time: 10.0 } } }

      it 'applies BOGOF rule correctly' do
        service.apply_pricing_rule

        expect(cart_data[product.code][:total_items]).to eq(6)
        expect(cart_data[product.code][:free_items]).to eq(2)
        expect(cart_data[product.code][:total_payable]).to eq(40.0)
      end
    end
  end

  describe 'No applicable rules' do
    let(:quantity) { 1 }
    before { cart_data[product.code] = { quantity: 0, price_at_purchase_time: 10.0 } }

    it 'keeps original price if no rules apply' do
      service.apply_pricing_rule

      expect(cart_data[product.code][:total_payable]).to eq(10.0)
      expect(cart_data[product.code][:quantity]).to eq(1)
    end
  end
end
