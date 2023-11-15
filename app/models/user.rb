class User < ApplicationRecord
  belongs_to :province
  has_many :reviews
  has_many :books, through: :reviews
  has_many :orders
  has_many :book_orders, through: :orders

  validates :username, :email, :first_name, :last_name, presence: true
  validates :username, :email, uniqueness: true

  # Validation for username format (alphanumeric characters, underscores, and dashes)
  validates :username,
            format: { with:    /\A[a-zA-Z0-9_.-]+\z/,
                      message: " Username can only contain letters, numbers, underscores, and dashes" }

  # Validation for email format
  validates :email,
            format: { with:    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
                      message: "Must be a valid email address" }

  # Validation for length (assuming minimum and maximum lengths)
  validates :username, length: { minimum: 3, maximum: 30 }
  validates :first_name, :last_name, length: { maximum: 50 }
end
