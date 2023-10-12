class ApplicationController < ActionController::Base
  before_action :set_categories

  private

  def set_categories
    # @categories includes all the columns of the categories table, plus a "book_count" column.
    @categories = Category.joins(:books).group("categories.id").select("categories.*, COUNT(books.id) AS book_count").order(:name)
  end
end
