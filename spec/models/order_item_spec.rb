# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it 'has a valid factory' do
    expect(create(:order_item)).to be_valid # Ensure you have a factory for order items
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      order = create(:order)
      product = create(:product)
      order_item = OrderItem.new(order: order, product: product, quantity: 1, price_at_purchase_time: 10.0)
      expect(order_item).to be_valid
    end

    it 'is invalid without a quantity' do
      order_item = OrderItem.new(quantity: nil)
      expect(order_item).not_to be_valid
      expect(order_item.errors[:quantity]).to include("can't be blank")
    end

    it 'is invalid with a non-integer quantity' do
      order_item = OrderItem.new(quantity: 1.5)
      expect(order_item).not_to be_valid
      expect(order_item.errors[:quantity]).to include('must be an integer')
    end

    it 'is invalid with a negative quantity' do
      order_item = OrderItem.new(quantity: -1)
      expect(order_item).not_to be_valid
      expect(order_item.errors[:quantity]).to include('must be greater than 0')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }
  end
end
