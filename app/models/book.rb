class Book < ApplicationRecord
  belongs_to :category
  has_one_attached :cover_image

  validates :title, presence: true
  validates :author, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :on_sale, -> { where(on_sale: true) }
  scope :recently_updated, -> {
  where(updated_at: 3.days.ago..Time.now)
  .where("created_at < ?", 3.days.ago)
}

scope :new_arrivals, -> {
  where(created_at: 3.days.ago..Time.now)
}

  def self.ransackable_attributes(auth_object = nil)
    [ "author", "category_id", "created_at", "description", "id",
     "on_sale", "price", "stock_quantity", "title", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "category" ]
  end
end
