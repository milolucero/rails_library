class CategoriesController < ApplicationController
  def index
    # @all_categories is already defined in the application_controller
    @categories = @all_categories
  end

  def show
    @category = Category.find_by(name: params[:category_name])
    @books = @category.books
  end
end
