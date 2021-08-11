class User < ApplicationRecord
  has_many :reviews
  has_many :ratings
  has_many :products
  has_many :carts
  has_many :orders, dependent: :destroy
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :password, format: {with: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./,:multiline => true,
    message: "must include at least one lowercase letter, one uppercase letter, and one digit"}
end
