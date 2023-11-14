class Order < ApplicationRecord
  belongs_to :user
  has_many :book_orders
  has_many :books, through: :book_orders
end
