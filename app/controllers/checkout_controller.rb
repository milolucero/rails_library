class CheckoutController < ApplicationController
  # Ensure the user is authenticated to reach this page
  before_action :authenticate_user!

  def index
    @order_is_valid = false
    @edit_address = session[:edit_address]
    session[:edit_address] = false

    # If the user has a province, calculate taxes
    if current_user.province_id.present?
      @province = Province.find(current_user.province_id)
      @total_pst = @province.pst * @cart_subtotal
      @total_gst = @province.gst * @cart_subtotal
      @total_hst = @province.hst * @cart_subtotal
      @total_taxes = @total_pst + @total_gst + @total_hst
      @cart_total = @cart_subtotal + @total_taxes
    end

    # If the user has complete shipping details, enable the "Proceed to Payment" button.
    if current_user.address.present? && current_user.city.present? && current_user.province.present? && current_user.postal_code.present?
      @order_is_valid = true
    end
  end

  def update_user_address

  end

  # Called when the "Proceed to Payment" button is clicked
  def create
    if @cart.empty?
      redirect_to root_path
    end

    # Calculate taxes
    @province = Province.find(current_user.province_id)
    @total_gst = @province.gst * @cart_subtotal
    @total_pst = @province.pst * @cart_subtotal
    @total_hst = @province.hst * @cart_subtotal

    # If the user has complete shipping details, create the order.
    if current_user.address.present? && current_user.city.present? && current_user.province.present? && current_user.postal_code.present?
      @order = Order.create!(
        user_id: current_user.id,
        shipping_address: current_user.address,
        shipping_city: current_user.city,
        shipping_province: @province.name,
        shipping_postal_code: current_user.postal_code,
        subtotal: @cart_subtotal,
        purchase_gst: @province.gst,
        purchase_pst: @province.pst,
        purchase_hst: @province.hst,
        status: "Pending"
      )

      # Save the order
      if @order.save
        # Add cart books to book_order
        @cart.each do |book|
          @book = Book.find(book["id"])
          @book_price = @book.is_on_sale? ? @book.sale_price : @book.price

          BookOrder.create!(
            order_id: @order.id,
            book_id: @book.id,
            purchase_price: @book_price,
            quantity: book["quantity"],
          )
        end
      else
        flash[:error] = "There was a problem creating your order. Please try again."
        puts @order.errors.full_messages
        render :index
      end
    else
      flash[:error] = "The shipping details are incomplete. The order could not be created."
    end

    # Create Stripe session
    @session=Stripe::Checkout::Session.create(
      payment_method_types:["card"],
      success_url: checkout_pre_success_url,
      cancel_url: checkout_cancel_url,
      mode:"payment",
      line_items: @cart.map do |item|
        @book = Book.find(item["id"])
        @book_price = @book.is_on_sale? ? @book.sale_price : @book.price

        {
          quantity: item["quantity"],
          price_data: {
            currency: "cad",
            unit_amount: (@book_price * 100).to_i,
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

  def update_user_address
    session[:edit_address] = true
    redirect_to action: "index"
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
