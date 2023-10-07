class CreateSaleInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :sale_infos do |t|
      t.decimal :price
      t.string :currency
      t.string :buy_link

      t.timestamps
    end
  end
end
