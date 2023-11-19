class BookCategory < ApplicationRecord
  belongs_to :book
  belongs_to :category

  validates :book_id,
            uniqueness: { scope:   :category_id,
                          message: "This category has already been added to this book" }
end
