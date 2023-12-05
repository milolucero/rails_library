class BooksController < ApplicationController
  def index
    @books = Book.page(params[:page]).per(20)
    apply_filters
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

    if keywords.present?
      @books = @books.where("title LIKE ? OR description LIKE ?", "%#{keywords}%", "%#{keywords}%")
    end

    if category_id.present?
      @books = @books.joins(:categories).where(book_categories: { category_id: category_id })
    end

    @books = @books.page(params[:page]).per(20)
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

    redirect_to cart_path
  end

  def update_quantity
    id = params[:id].to_i
    quantity = params[:quantity].to_i

    book = @cart.find { |book_order| book_order["id"] == id }

    if book
      book["quantity"] = quantity
    end

    redirect_to cart_path
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

    redirect_to cart_path
  end

  #
  def apply_filters
    filter_conditions = []

    if params[:on_sale].present?
      filter_conditions << { is_on_sale: true }
    end

    if params[:new].present?
      filter_conditions << ['books.created_at >= ?', 3.days.ago]
    end

    if params[:recently_updated].present?
      # Filter based on recently updated, excluding new products
      filter_conditions << ['books.updated_at >= ? AND books.created_at < ?', 3.days.ago, 3.days.ago]
    end


    # Apply all filter conditions to @books
    filter_conditions.each do |condition|
      if condition.is_a?(Hash)
        @books = @books.where(condition)
      else
        @books = @books.where(*condition)
      end
    end
  end
end
