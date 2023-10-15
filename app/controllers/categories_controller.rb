class CategoriesController < ApplicationController
  def index
    # @categories is already defined in the application_controller
  end

  def show
    @category = Category.find_by(name: params[:category_name])
    @books = @category.books
  end
end
