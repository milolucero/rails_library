class Book < ApplicationRecord
  belongs_to :publisher
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :categories
  has_many :users, through: :reviews
  belongs_to :sale_info, dependent: :destroy
end
