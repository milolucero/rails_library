class BookOrder < ApplicationRecord
  belongs_to :order
  belongs_to :book

  validates :book_id, presence: true
  validates :order_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
end
