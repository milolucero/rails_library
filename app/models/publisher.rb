class Publisher < ApplicationRecord
  has_many :books

  validates :name, uniqueness: true
end
