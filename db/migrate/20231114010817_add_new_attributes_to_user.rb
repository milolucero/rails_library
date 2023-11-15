class AddNewAttributesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password, :string
    add_column :users, :city, :string
    add_column :users, :postal_code, :string
  end
end
