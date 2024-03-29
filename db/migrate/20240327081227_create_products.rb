# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :code, null: false
      t.string :name, null: false, default: ''
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0.0

      t.timestamps
    end

    add_index :products, :code, unique: true
  end
end
