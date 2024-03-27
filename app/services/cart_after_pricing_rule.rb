# frozen_string_literal: true

class CartAfterPricingRule
  def initialize(cart_data, product_code, quantity)
    @cart_data = cart_data
    @product = Product.find_by(code: product_code)
    @additional_quantity = quantity

    @cart_item = cart_data[product_code] || { quantity: 0, price_at_purchase_time: @product.price.to_f }
    @cart_item = @cart_item.deep_symbolize_keys
  end

  def apply_pricing_rule
    return @cart_item unless @product && @additional_quantity.positive?

    update_cart_item_quantity
    apply_best_pricing_rule

    @cart_data[@product.code] = @cart_item
  end

  private

  def update_cart_item_quantity
    @cart_item[:quantity] += @additional_quantity
    @cart_item[:price_at_purchase_time] = @product.price.to_f
  end

  def apply_best_pricing_rule
    active_rules = @product.pricing_rules.active

    if active_rules.exists?(rule_type: 'bogof')
      pricing_rule = active_rules.find_by(rule_type: 'bogof')
      apply_bogof(pricing_rule) if pricing_rule
    else
      @cart_item[:total_payable] = (@cart_item[:quantity] * @cart_item[:price_at_purchase_time]).to_f

      pricing_rule = active_rules
                     .where('threshold_quantity <= ?', @cart_item[:quantity])
                     .where.not(rule_type: 'bogof')
                     .order(:threshold_quantity)
                     .last

      return unless pricing_rule

      case pricing_rule.rule_type
      when 'bulk_purchase'
        apply_bulk_purchase(pricing_rule)
      when 'volume_discount'
        apply_volume_discount(pricing_rule)
      end
    end
  end

  def apply_bulk_purchase(pricing_rule)
    @cart_item[:total_payable] = (pricing_rule.discount_price * @cart_item[:quantity]).to_f
  end

  def apply_bogof(pricing_rule)
    @cart_item[:discount_type] = 'Buy one get one free'
    @cart_item[:free_items] ||= 0
    total_ordered = @cart_item[:quantity]
    free_items_to_add = [@additional_quantity, pricing_rule.threshold_quantity].min
    @cart_item[:free_items] = [@cart_item[:free_items] + free_items_to_add, pricing_rule.threshold_quantity].min
    total_items = total_ordered + @cart_item[:free_items]
    @cart_item[:total_payable] = total_ordered * @cart_item[:price_at_purchase_time]
    @cart_item[:total_items] = total_items
  end

  def apply_volume_discount(pricing_rule)
    @cart_item[:total_discount] =
      (@cart_item[:price_at_purchase_time] * pricing_rule.discount_rate * @cart_item[:quantity]).to_f
    @cart_item[:total_payable] =
      ((@cart_item[:price_at_purchase_time] * @cart_item[:quantity]) - @cart_item[:total_discount]).to_f
  end

  def has_bogof_rule?
    @product.pricing_rules.active.exists?(rule_type: 'bogof')
  end
end
