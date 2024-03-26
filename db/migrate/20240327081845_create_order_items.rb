# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.decimal :price_at_purchase_time, precision: 10, scale: 2
      t.decimal :price_after_discount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
