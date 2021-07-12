class AddPriceToLineItems < ActiveRecord::Migration[6.1]
  def change
    add_column :line_items, :price, :float
  end
end
