class CartController < ApplicationController
  def index
    @cart_total = @cart.sum do |item|
      book = Book.find(item["id"])
      unit_price = book.is_on_sale ? book.sale_price : book.price
      item["quantity"] * unit_price
    end
  end
end
