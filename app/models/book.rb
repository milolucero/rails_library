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

  # Custom validation example (you can define your own validation logic)
  validate :published_date_cannot_be_in_the_future

  # Custom validation method
  def published_date_cannot_be_in_the_future
    return unless published_date.present? && published_date > Date.today

    errors.add(:published_date, "can't be in the future")
  end
end
