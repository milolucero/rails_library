class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  belongs_to :province, optional: true
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

  # Password validations
  validates :password, presence: true, length: { minimum: 8 }
  validates :password, confirmation: true, unless: -> { password.blank? }

  # Validation for length (assuming minimum and maximum lengths) of attribures.
  validates :username, length: { minimum: 3, maximum: 30 }
  validates :first_name, :last_name, length: { maximum: 50 }
  validates :address, length: { maximum: 100 }
  validates :city, length: { maximum: 60 }

  # Validation for postal code format
  validates :postal_code,
            format: { with: /\A[ABCEGHJKLMNPRSTVXY]\d[ABCEGHJKLMNPRSTVWXYZ] ?\d[ABCEGHJKLMNPRSTVWXYZ]\d\z/i },
            allow_nil: true,
            allow_blank: true
end
