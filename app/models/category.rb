class Category < ApplicationRecord
  has_many   :products, dependent: :destroy
  has_many   :subcategories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: 'Category', foreign_key: 'parent_id', optional: true
  validates :category_name, presence: true
end
