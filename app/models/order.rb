class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :province, optional: true
  has_many :order_items, dependent: :destroy
  has_many :books, through: :order_items

  STATUSES = %w[pending paid shipped].freeze

  validates :status, presence: true,
            inclusion: { in: STATUSES }

  scope :pending, -> { where(status: "pending") }
  scope :paid, -> { where(status: "paid") }
  scope :shipped, -> { where(status: "shipped") }

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
