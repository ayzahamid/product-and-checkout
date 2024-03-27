# frozen_string_literal: true

class CartsController < ApplicationController
  def index
    @cart_items = session[:cart] || {}
  end

  def add
    session[:cart] ||= {}

    product_code = params[:product_code]
    quantity = params[:quantity].to_i

    if product_code.present? && quantity.positive?
      CartAfterPricingRule.new(session[:cart], product_code, quantity).apply_pricing_rule

      redirect_to products_path, notice: 'Product added to cart successfully!'
    else
      message = product_code.blank? ? 'No product code found' : 'Invalid product code or quantity'
      redirect_to products_path, alert: message
    end
  end

  def reset
    session[:cart] = {}
    redirect_to products_path, alert: "Cart reset successfully!"
  end
end
