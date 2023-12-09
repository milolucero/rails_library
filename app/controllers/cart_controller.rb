class CartController < ApplicationController
  before_action :authenticate_user!, only: [:checkout]

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
end
