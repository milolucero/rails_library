class ApplicationController < ActionController::Base
  before_action :set_variables


  private

  def set_variables
    # @all_categories includes all the columns of the categories table, plus a "book_count" column.
    @all_categories = Category.joins(:books).group("categories.id").select("categories.*, COUNT(books.id) AS book_count").order(:name)
    @publishers = Publisher.all
  end
end
