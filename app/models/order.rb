# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id          :bigint           not null, primary key
#  notes       :text
#  status      :string           default("pending"), not null
#  total_price :decimal(10, 2)   default(0.0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Order < ApplicationRecord
  ALLOWED_STATUSES = ['pending', 'in transit', 'completed', 'cancelled'].freeze

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true, inclusion: { in: ALLOWED_STATUSES }
  validates :total_price, presence: true, numericality: { greater_than: 0.0 }
end
