class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "email", "id", "name", "updated_at", "province_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "orders", "province" ]
  end
end
