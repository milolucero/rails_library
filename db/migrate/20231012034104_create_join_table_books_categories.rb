class CreateJoinTableBooksCategories < ActiveRecord::Migration[7.0]
  def change
    create_join_table :books, :categories do |t|
      # t.index [:book_id, :category_id]
      # t.index [:category_id, :book_id]
    end
  end
end
