class Book < ApplicationRecord
  belongs_to :category
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags
  has_one_attached :cover_image do |attachable|
    attachable.variant :thumb, resize_to_fill: [ 100, 150 ]
    attachable.variant :medium, resize_to_fill: [ 200, 300 ]
    attachable.variant :large, resize_to_fill: [ 400, 600 ]
  end

  validates :title, presence: true, length: { maximum: 200 }
  validates :author, presence: true, length: { maximum: 200 }
  validates :description, presence: true
  validates :price, presence: true,
            numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, presence: true,
            numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :on_sale, -> { where(on_sale: true) }
  scope :new_arrivals, -> { where(created_at: 3.days.ago..Time.now) }
  scope :recently_updated, -> {
    where(updated_at: 3.days.ago..Time.now)
    .where("created_at < ?", 3.days.ago)
  }

  def self.ransackable_attributes(auth_object = nil)
    [ "author", "category_id", "created_at", "description", "id",
     "on_sale", "price", "stock_quantity", "title", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "category", "tags", "book_tags" ]
  end
end
