class Book < ApplicationRecord
  belongs_to :publisher, optional: true, inverse_of: :books
  has_and_belongs_to_many :authors, dependent: :destroy
  has_and_belongs_to_many :categories, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :users, through: :reviews
  belongs_to :sale_info, dependent: :destroy

  validates :title, presence: true

  # validates :published_date, :isbn, :page_count, :language, presence: true, allow_nil: true

  # Validation for uniqueness of ISBN
  validates :isbn, uniqueness: true, allow_nil: false

  # Validation for numericality of page_count
  validates :page_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                         allow_nil:    true

  def average_rating
    reviews.average(:rating).to_f
  end
end
