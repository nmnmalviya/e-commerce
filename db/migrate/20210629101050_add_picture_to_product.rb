class AddPictureToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products ,:picture ,:string
  end
end
