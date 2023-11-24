class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, :content, presence: true
end
