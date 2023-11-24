class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.string :phone
      t.string :email
      t.string :address
      t.string :slug

      t.timestamps
    end
  end
end
