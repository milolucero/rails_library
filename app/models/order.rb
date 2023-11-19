class Order < ApplicationRecord
  belongs_to :user
  has_many :book_orders
  has_many :books, through: :book_orders

  validates :customer_id, presence: true
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_gst, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_pst, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
end
