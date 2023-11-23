class BooksController < ApplicationController
  def index
    @books = Book.page(params[:page]).per(12)
  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews
  end

  def search
    @categories = @all_categories
    keywords = params[:keywords]
    category_id = params[:category_id]

    @books = Book.all

    if category_id.present?
      @books = @books.joins(:categories).where(book_categories: { category_id: category_id })
    end

    if keywords.present?
      @books = @books.where("title LIKE ? OR description LIKE ?", "%#{keywords}%", "%#{keywords}%")
    end

    @books = @books.page(params[:page]).per(12)
  end

  def add_to_cart
    id = params[:id].to_i
    quantity = params[:quantity].to_i

    # Look for an element matching the id.
    # If there is a match, add to the quantity.
    # Otherwise, set the quantity.
    book = @cart.find { |book_order| book_order["id"] == id }

    if book
      book["quantity"] += quantity
    else
      @cart << { id:, quantity: }
    end

    redirect_to root_path
  end

  def remove_from_cart
    id = params[:id].to_i
    quantity = params[:quantity].to_i

    # Look for an element matching the id.
    # If there is a match, subtract from the quantity.
    # If result is less than or equals to zero, delete the item from the cart.
    book = @cart.find { |book_order| book_order["id"] == id }

    if book
      book["quantity"] -= quantity

      if book["quantity"] <= 0
        @cart.delete_if { |book_order| book_order["id"] == id }
      end
    end

    redirect_to root_path
  end
end
