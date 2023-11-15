class Province < ApplicationRecord
  has_many :users

  validates :name, presence: true, length: { maximum: 30 }
  validates :name_abbreviation, presence: true, length: { maximum: 2 }
  validates :gst, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :pst, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hst, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
