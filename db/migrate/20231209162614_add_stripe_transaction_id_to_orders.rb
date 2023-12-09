class AddStripeTransactionIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :stripe_transaction_id, :string
  end
end
