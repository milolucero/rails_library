class BooksController < ApplicationController
  def index
    @books = Book.page(params[:page]).per(12)
  end

  def show
    @book = Book.find(params[:id])

    @reviews = @book.reviews
  end

  def search
      @categories = Category.all
      keywords = params[:keywords]
      category_id = params[:category_id]

      @books = Book.all

      if keywords.present?
        @books = @books.where("title LIKE ? OR description LIKE ?", "%#{keywords}%", "%#{keywords}%")
      end

      if category_id.present?
        # Ensure you have the correct association name between Book and Category
        @books = @books.joins(:categories).where(categories: { id: category_id })
      end

  end
end
