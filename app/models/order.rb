class Order < ApplicationRecord
  belongs_to :user
  has_one :cart ,dependent: :destroy
  has_many :line_items  
  validates :name,:email,:address, presence:true
  validates :number ,presence:true,:numericality => true,
                 :length => { :minimum => 10, :maximum => 13 }
end
