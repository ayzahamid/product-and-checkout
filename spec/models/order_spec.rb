# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'has a valid factory' do
    expect(create(:order)).to be_valid # Ensure you have a factory for orders
  end

  it 'is valid with a status and a total_price' do
    order = Order.new(status: 'pending', total_price: 100.0)
    expect(order).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a status' do
      order = Order.new(status: nil)
      expect(order).not_to be_valid
      expect(order.errors[:status]).to include("can't be blank")
    end

    it 'is invalid with an unrecognized status' do
      order = Order.new(status: 'unknown')
      expect(order).not_to be_valid
      expect(order.errors[:status]).to include('is not included in the list')
    end

    it 'is invalid without a total_price' do
      order = Order.new(total_price: nil)
      expect(order).not_to be_valid
      expect(order.errors[:total_price]).to include("can't be blank")
    end

    it 'is invalid with a negative total_price' do
      order = Order.new(total_price: -1.0)
      expect(order).not_to be_valid
      expect(order.errors[:total_price]).to include('must be greater than 0.0')
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:order_items) }
  end
end
