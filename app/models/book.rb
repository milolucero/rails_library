class Book < ApplicationRecord
  belongs_to :publisher, optional: true, inverse_of: :books

  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories

  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors

  has_many :reviews, dependent: :destroy
  has_many :users, through: :reviews

  has_many :book_orders
  has_many :orders, through: :book_orders

  accepts_nested_attributes_for :book_categories, allow_destroy: true
  accepts_nested_attributes_for :book_authors, allow_destroy: true

  has_one_attached :image

  validates :title, presence: true
  validates :published_date, :description, :isbn, :page_count, :language, presence:  true,
                                                                          allow_nil: false

  # Validation for uniqueness of ISBN
  validates :isbn, uniqueness: true, allow_nil: false

  # Validation for numericality of page_count
  validates :page_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                         allow_nil:    true

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :is_on_sale, inclusion: { in: [true, false] }
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }, if: :is_on_sale?

  def average_rating
    format("%.1f", reviews.average(:rating).to_f)
  end
end
