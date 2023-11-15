class AddNewAttributesToBook < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :price, :decimal
    add_column :books, :is_on_sale, :boolean
    add_column :books, :sale_price, :decimal
  end
end
