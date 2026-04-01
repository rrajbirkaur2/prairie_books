class Province < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :gst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :pst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :hst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end