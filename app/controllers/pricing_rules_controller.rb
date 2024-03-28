# frozen_string_literal: true

class PricingRulesController < ApplicationController
  before_action :set_product

  def edit
    @pricing_rule = @product.pricing_rule || @product.build_pricing_rule
  end

  def create
    @pricing_rule = @product.build_pricing_rule(pricing_rule_params)
    if @pricing_rule.save
      redirect_to products_path, notice: 'Pricing plan created successfully.'
    else
      render :edit
    end
  end

  def update
    @pricing_rule = @product.pricing_rule
    if @pricing_rule.update(pricing_rule_params)
      redirect_to products_path, notice: 'Pricing plan updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def pricing_rule_params
    params.require(:pricing_rule).permit(:discount_price, :discount_rate, :rule_type, :threshold_quantity, :active)
  end
end
