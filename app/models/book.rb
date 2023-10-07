class Book < ApplicationRecord
  belongs_to :publisher
  belongs_to :sale_info
end
