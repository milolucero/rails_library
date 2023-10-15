class BooksController < ApplicationController
  def index
    @books = Book.page(params[:page]).per(25)
  end

  def show
    @book = Book.find(params[:id])

    @reviews = @book.reviews
  end
end
