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
    session[:cart] << params[:id]
    redirect_to root_path
  end
end
