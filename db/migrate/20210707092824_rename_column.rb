class RenameColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :orders, :Total, :total
  end
end
