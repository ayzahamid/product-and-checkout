# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           default(""), not null
#  price      :decimal(10, 2)   default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_products_on_code  (code) UNIQUE
#

class Product < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :pricing_rules

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
end
