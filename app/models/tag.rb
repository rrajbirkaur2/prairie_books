class Tag < ApplicationRecord
  has_many :book_tags, dependent: :destroy
  has_many :books, through: :book_tags

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
  ["created_at", "id", "name", "updated_at"]
end

def self.ransackable_associations(auth_object = nil)
  ["books", "book_tags"]
end
end