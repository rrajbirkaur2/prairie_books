class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :book

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_at_purchase, presence: true, numericality: { greater_than_or_equal_to: 0.01 }

  def subtotal
    price_at_purchase * quantity
  end
end