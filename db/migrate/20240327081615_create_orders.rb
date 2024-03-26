# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :status, null: false, default: 'pending'
      t.decimal :total_price, precision: 10, scale: 2, null: false, default: 0.0
      t.text :notes

      t.timestamps
    end
  end
end
