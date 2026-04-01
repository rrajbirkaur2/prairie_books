class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy
  has_many :books, through: :order_items

  validates :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "status", "total_price", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "order_items", "books"]
  end
end