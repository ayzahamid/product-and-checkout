# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_240_327_082_049) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'order_items', force: :cascade do |t|
    t.bigint 'order_id', null: false
    t.bigint 'product_id', null: false
    t.integer 'quantity', default: 1, null: false
    t.decimal 'price_at_purchase_time', precision: 10, scale: 2
    t.decimal 'price_after_discount', precision: 10, scale: 2
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['order_id'], name: 'index_order_items_on_order_id'
    t.index ['product_id'], name: 'index_order_items_on_product_id'
  end

  create_table 'orders', force: :cascade do |t|
    t.string 'status', default: 'pending', null: false
    t.decimal 'total_price', precision: 10, scale: 2, default: '0.0', null: false
    t.text 'notes'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'pricing_rules', force: :cascade do |t|
    t.string 'rule_type'
    t.integer 'threshold_quantity'
    t.decimal 'discount_price', precision: 10, scale: 2
    t.decimal 'discount_rate', precision: 5, scale: 2
    t.boolean 'active', default: true
    t.bigint 'product_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['product_id'], name: 'index_pricing_rules_on_product_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'code', null: false
    t.string 'name', default: '', null: false
    t.decimal 'price', precision: 10, scale: 2, default: '0.0', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['code'], name: 'index_products_on_code', unique: true
  end

  add_foreign_key 'order_items', 'orders'
  add_foreign_key 'order_items', 'products'
  add_foreign_key 'pricing_rules', 'products'
end
