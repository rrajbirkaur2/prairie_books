class Book < ApplicationRecord
  belongs_to :category

  validates :title, presence: true
  validates :author, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    ["author", "category_id", "created_at", "description", "id", "price", "stock_quantity", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end
end