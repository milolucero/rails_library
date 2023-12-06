class CartController < ApplicationController
  before_action :authenticate_user!, only: [:checkout]
  before_action :set_cart_subtotal

  def index

  end

  def checkout
    @province = Province.find(current_user.province_id)
    @total_pst = @province.pst * @cart_subtotal
    @total_gst = @province.gst * @cart_subtotal
    @total_hst = @province.hst * @cart_subtotal
    @total_taxes = @total_pst + @total_gst + @total_hst
    @cart_total = @cart_subtotal + @total_taxes
  end

  # Create, Cancel and Success actions for Stripe integration
  def create
    # code to create a new checkout
  end

  def cancel
    # code to cancel the checkout
  end

  def success
    # code to handle successful checkout
  end

  private

  def set_cart_subtotal
    @cart_subtotal = @cart.sum do |item|
      book = Book.find(item["id"])
      unit_price = book.is_on_sale ? book.sale_price : book.price
      item["quantity"] * unit_price
    end
  end
end
