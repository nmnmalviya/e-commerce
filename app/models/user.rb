class User < ApplicationRecord
  has_many :products
  has_many :carts
  has_many :orders, dependent: :destroy
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :password, length: { minimum: 8, maximum: 13 }
end
