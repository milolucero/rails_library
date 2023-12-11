class OrdersController < ApplicationController
  before_action :authenticate_user!

  # All orders of the current user
  def index
    @user = current_user
    @orders = @user.orders.includes(book_orders: :book)
  end

  # Details about the order
  def show
    @user = current_user
    @order = @user.orders.find(params[:id])
    @book_orders = @order.book_orders.includes(:book)
  end
end
