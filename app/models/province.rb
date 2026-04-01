class Province < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :gst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :pst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :hst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst", "hst", "id", "name", "pst", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["users"]
  end
end