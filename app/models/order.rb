class Order < ApplicationRecord
  belongs_to :user
  has_many :book_orders
  has_many :books, through: :book_orders

  validates :user_id, presence: true
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :purchase_gst, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :purchase_pst, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :purchase_hst, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
end
