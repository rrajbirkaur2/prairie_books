# Relationships:
# - belongs_to User (many orders to one user - one-to-many)
# - belongs_to Province (many orders to one province - one-to-many)
# - has_many OrderItems (one order to many items - one-to-many)
# - has_many Books through OrderItems (many-to-many)

class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :province, optional: true
  has_many :order_items, dependent: :destroy
  has_many :books, through: :order_items

  STATUSES = %w[pending paid shipped].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :subtotal, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :grand_total, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :gst_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :pst_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :hst_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def self.ransackable_attributes(auth_object = nil)
    [ "address", "city", "created_at", "grand_total", "gst_amount",
     "gst_rate", "hst_amount", "hst_rate", "id", "postal_code",
     "province_id", "pst_amount", "pst_rate", "status",
     "stripe_payment_id", "subtotal", "total_price",
     "updated_at", "user_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user", "order_items", "books", "province" ]
  end
end
