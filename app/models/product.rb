class Product < ApplicationRecord
  has_many :reviews
  has_many :ratings
  has_many :line_items, dependent: :destroy
  belongs_to :category
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :name, :about, :price, :picture, presence: true
end
