class SaleInfo < ApplicationRecord
  has_one :book

  validates :price, :currency, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
