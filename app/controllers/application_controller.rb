class ApplicationController < ActionController::Base
  before_action :initialize_session
  before_action :increment_visit_count
  before_action :set_variables

  private

  def initialize_session
    session[:visit_count] ||= 0
    session[:cart] ||= []
  end

  def increment_visit_count
    session[:visit_count] += 1
    @visit_count = session[:visit_count]
  end

  def set_variables
    # @all_categories includes all the columns of the categories table, plus a "book_count" column.
    @all_categories = Category.joins(:books).group("categories.id").select("categories.*, COUNT(books.id) AS book_count").order(:name)
    @publishers = Publisher.all
  end
end
