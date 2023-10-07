class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :book_id, :user_id, :rating, presence: true
  validates :rating, numericality: {
    only_integer:             true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to:    5
  }

  validates :book_id,
            uniqueness: { scope: :user_id, message: "Has already been rated by this user" }

  validate :rating_comment_length

  # Custom validation method to check the length of the comment
  def rating_comment_length
    return unless comment.present? && comment.length > 500

    errors.add(:comment, "comment is too long (maximum is 500 characters)")
  end
end
