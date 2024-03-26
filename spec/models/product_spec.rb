# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'is valid with valid attributes' do
    product = Product.new(code: '001', name: 'Test Product', price: 10.0)
    expect(product).to be_valid
  end

  it 'is not valid without a code' do
    product = Product.new(code: nil, name: 'Test Product', price: 10.0)
    expect(product).not_to be_valid
    expect(product.errors[:code]).to include("can't be blank")
  end

  it 'is not valid without a name' do
    product = Product.new(code: '001', name: nil, price: 10.0)
    expect(product).not_to be_valid
    expect(product.errors[:name]).to include("can't be blank")
  end

  it 'is not valid with a negative price' do
    product = Product.new(code: '001', name: 'Test Product', price: -1.0)
    expect(product).not_to be_valid
    expect(product.errors[:price]).to include('must be greater than or equal to 0.0')
  end

  it 'is not valid with a duplicate code' do
    Product.create(code: '001', name: 'Original Product', price: 10.0)
    duplicate = Product.new(code: '001', name: 'Duplicate Product', price: 10.0)
    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:code]).to include('has already been taken')
  end

  describe 'associations' do
    it { should have_many(:order_items) }
    it { should have_many(:orders).through(:order_items) }
    it { should have_many(:pricing_rules) }
  end
end
