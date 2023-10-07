class Book < ApplicationRecord
  belongs_to :publisher
  has_and_belongs_to_many :authors, dependent: :destroy
  has_and_belongs_to_many :categories, dependent: :destroy
  has_many :reviews
  has_many :users, through: :reviews
  belongs_to :sale_info, dependent: :destroy
end
