class AddShippingDetailsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :shipping_address, :string
    add_column :orders, :shipping_city, :string
    add_column :orders, :shipping_province, :string
    add_column :orders, :shipping_postal_code, :string
  end
end
