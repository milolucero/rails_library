class CheckoutController < ApplicationController
  def index
    @province = Province.find(current_user.province_id)
    @total_pst = @province.pst * @cart_subtotal
    @total_gst = @province.gst * @cart_subtotal
    @total_hst = @province.hst * @cart_subtotal
    @total_taxes = @total_pst + @total_gst + @total_hst
    @cart_total = @cart_subtotal + @total_taxes
  end

  def create
    # Only used on the Pay button as a hidden field to send product data
    # @product = Product.find(params[:product_id])

    if @cart.empty?
      redirect_to root_path
    end

    # Price calculations
    @cart_subtotal = @cart.sum do |item|
      book = Book.find(item["id"])
      unit_price = book.is_on_sale ? book.sale_price : book.price
      item["quantity"] * unit_price
    end
    @province = Province.find(current_user.province_id)
    @total_pst = @province.pst * @cart_subtotal
    @total_gst = @province.gst * @cart_subtotal
    @total_hst = @province.hst * @cart_subtotal
    @total_taxes = @total_pst + @total_gst + @total_hst
    @cart_total = @cart_subtotal + @total_taxes

    # Create Stripe session
    @session=Stripe::Checkout::Session.create(
      payment_method_types:["card"],
      success_url: checkout_pre_success_url,
      cancel_url: checkout_cancel_url,
      mode:"payment",
      line_items: @cart.map do |item|
        @book = Book.find(item["id"])

        {
          quantity: item["quantity"],
          price_data: {
            currency: "cad",
            unit_amount: (@book.price * 100).to_i,
            product_data: {
                name: @book.title,
            },
          }
        }
      end.append(
        {
          quantity: 1,
          price_data: {
            currency: "cad",
            unit_amount: (@total_gst * 100).to_i,
            product_data: {
                name: "GST",
            },
          }
        },
        {
          quantity: 1,
          price_data: {
            currency: "cad",
            unit_amount: (@total_pst * 100).to_i,
            product_data: {
                name: "PST",
            },
          }
        },
        {
          quantity: 1,
          price_data: {
            currency: "cad",
            unit_amount: (@total_hst * 100).to_i,
            product_data: {
                name: "HST",
            },
          }
        },
      )
    )

    redirect_to @session.url, allow_other_host: true
  end

  # This action is used to empty the cart before redirecting to the success page
  def pre_success
    # Empty cart
    session[:cart] = []
    @cart = session[:cart]

    # Add order to database

    # Force a reload of the current resource to ensure the view gets the updated @cart
    redirect_to checkout_success_path
  end

  def success
  end

  def Cancel

  end
end
