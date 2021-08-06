class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :order,optional:true
  has_many :line_items,dependent: :destroy
  has_many :products ,through: :line_items

  scope :unorderd, ->{where(status:"unorderd")}
end
 