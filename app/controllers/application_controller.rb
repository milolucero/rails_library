class ApplicationController < ActionController::Base
  before_action :set_variables


  private

  def set_variables
    # @categories includes all the columns of the categories table, plus a "book_count" column.
    @categories = Category.joins(:books).group("categories.id").select("categories.*, COUNT(books.id) AS book_count").order(:name)
    @publishers = Publisher.all
  end
end
