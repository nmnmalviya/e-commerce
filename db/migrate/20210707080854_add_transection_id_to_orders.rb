class AddTransectionIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :transection_id, :string
  end
end
