class Book < ApplicationRecord
  belongs_to :publisher
  has_and_belongs_to_many :authors, dependent: :destroy
  has_and_belongs_to_many :categories, dependent: :destroy
  has_many :reviews
  has_many :users, through: :reviews
  belongs_to :sale_info, dependent: :destroy

  validates :title, :published_date, :isbn, :page_count, :language, presence: true

  # Validation for uniqueness of ISBN
  validates :isbn, uniqueness: true

  # Validation for numericality of page_count
  validates :page_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
