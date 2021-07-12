class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :number
      t.text :address
      t.float :Total
      t.string :email

      t.timestamps
    end
  end
end
