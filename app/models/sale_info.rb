class SaleInfo < ApplicationRecord
  has_one :book

  # Validation for presence
  validates :price, :currency, presence: true

  # Validation for numericality of price
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # Validation for inclusion of currency code (assuming a specific set of currency codes)
  validates :currency, inclusion: { in: ["USD", "EUR", "GBP", "JPY", "CAD"] }

  # Validation for URL format of buy_link
  validates :buy_link, format: { with: %r{\Ahttps?://\S+\z}, message: "Must be a valid URL" }
end
