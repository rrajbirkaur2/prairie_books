class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :books, through: :cart_items

  def total_price
    cart_items.sum { |item| item.price_at_purchase * item.quantity }
  end

  def total_items
    cart_items.sum(:quantity)
  end
end
