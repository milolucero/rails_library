class CategoriesController < ApplicationController
  def index
    # @all_categories is already defined in the application_controller
    @categories = @all_categories
  end

  def show
    @category = Category.find_by(name: params[:category_name])
    @books = @category.books
    apply_filters
  end

  def apply_filters
    filter_conditions = []

    if params[:on_sale].present?
      filter_conditions << { is_on_sale: true }
    end

    if params[:new].present?
      filter_conditions << ['books.created_at >= ?', 3.days.ago]
    end

    if params[:recently_updated].present?
      # Filter based on recently updated, excluding new products
      filter_conditions << ['books.updated_at >= ? AND books.created_at < ?', 3.days.ago, 3.days.ago]
    end


    # Apply all filter conditions to @books
    filter_conditions.each do |condition|
      if condition.is_a?(Hash)
        @books = @books.where(condition)
      else
        @books = @books.where(*condition)
      end
    end
  end

end
