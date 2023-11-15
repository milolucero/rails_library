class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.references :publisher, null: true, foreign_key: true
      # t.references :publisher, null: false, foreign_key: true
      t.string :published_date
      t.text :description
      t.string :isbn
      t.integer :page_count
      t.string :language
      t.string :image_small_thumbnail
      t.string :image_thumbnail
      t.string :preview_link
      #t.references :sale_info, null: false, foreign_key: true
      t.string :search_info

      t.timestamps
    end
  end
end
