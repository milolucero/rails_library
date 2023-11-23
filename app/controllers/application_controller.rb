class ApplicationController < ActionController::Base
  before_action :initialize_session
  before_action :set_variables
  before_action :load_cart

  private

  def initialize_session
    session[:cart] ||= []
  end

  def load_cart
    @cart = session[:cart]
  end

  def set_variables
    # @all_categories includes all the columns of the categories table, plus a "book_count" column.
    @all_categories = Category.joins(:books).group("categories.id").select("categories.*, COUNT(books.id) AS book_count").order(:name)
    @publishers = Publisher.all
  end
end
