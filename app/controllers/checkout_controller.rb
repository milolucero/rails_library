class CheckoutController < ApplicationController
  def create
    # Only used on the Pay button as a hidden field to send product data
    # @product = Product.find(params[:product_id])

    if @cart.empty?
      redirect_to root_path
    end
  end

  def success

  end

  def Cancel

  end
end
