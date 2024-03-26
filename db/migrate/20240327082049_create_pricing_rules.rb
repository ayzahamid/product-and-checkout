# frozen_string_literal: true

class CreatePricingRules < ActiveRecord::Migration[6.1]
  def change
    create_table :pricing_rules do |t|
      t.string :rule_type
      t.integer :threshold_quantity
      t.decimal :discount_price, precision: 10, scale: 2
      t.decimal :discount_rate, precision: 5, scale: 2
      t.boolean :active, default: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
