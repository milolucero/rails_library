class User < ApplicationRecord
  has_many :reviews

  # Validation for presence
  validates :username, :email, :first_name, :last_name, presence: true

  # Validation for uniqueness
  validates :username, uniqueness: true
  validates :email, uniqueness: true

  # Validation for username format (alphanumeric characters, underscores, and dashes)
  validates :username,
            format: { with:    /\A[a-zA-Z0-9_-]+\z/,
                      message: " Username can only contain letters, numbers, underscores, and dashes" }

  # Validation for email format
  validates :email,
            format: { with:    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
                      message: "Must be a valid email address" }

  # Validation for length (assuming minimum and maximum lengths)
  validates :username, length: { minimum: 3, maximum: 30 }
  validates :first_name, :last_name, length: { maximum: 50 }

  # Custom validation example (you can define your own validation logic)
  validate :username_cannot_contain_special_characters

  # Custom validation method
  def username_cannot_contain_special_characters
    return unless username.present? && username.match(/[^a-zA-Z0-9_-]/)

    errors.add(:username, "can only contain letters, numbers, underscores, and dashes")
  end
end
