class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :subtotal
      t.decimal :purchase_gst
      t.decimal :purchase_pst
      t.decimal :purchase_hst
      t.string :status

      t.timestamps
    end
  end
end
