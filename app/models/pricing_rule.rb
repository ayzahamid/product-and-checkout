# frozen_string_literal: true

# == Schema Information
#
# Table name: pricing_rules
#
#  id                 :bigint           not null, primary key
#  active             :boolean          default(TRUE)
#  discount_price     :decimal(10, 2)
#  discount_rate      :decimal(5, 2)
#  rule_type          :string
#  threshold_quantity :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  product_id         :bigint           not null
#
# Indexes
#
#  index_pricing_rules_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#

class PricingRule < ApplicationRecord
  belongs_to :product

  enum rule_type: { bogof: 'bogof', bulk_purchase: 'bulk_purchase', volume_discount: 'volume_discount' }

  validates :rule_type, presence: true, inclusion: { in: rule_types.keys }
  validates :threshold_quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :discount_price, presence: true, numericality: { greater_than: 0.0 }, if: :bulk_purchase?
  validates :discount_rate, presence: true, numericality: { greater_than: 0.0, less_than: 1.0 }, if: :volume_discount?
  validates :active, inclusion: { in: [true, false] }

  scope :active, -> { where(active: true) }
end
