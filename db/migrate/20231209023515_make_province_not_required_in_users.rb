class MakeProvinceNotRequiredInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :province_id, true
  end
end
