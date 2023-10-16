class BooksController < ApplicationController
  def index
    @books = Book.page(params[:page]).per(10)
  end

  def show
    @book = Book.find(params[:id])

    @reviews = @book.reviews
  end

  def search
    keywords = params[:keywords]
    publisher_id = params[:book][:publisher_id]

    @books = Book.where("title LIKE ?", "%#{keywords}%")
    @books = @books.where(publisher_id:) if publisher_id.present?
  end
end
