class CreateBookCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :book_categories do |t|
      t.references :book, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
