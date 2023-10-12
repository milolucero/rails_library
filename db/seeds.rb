require "faker"
require "net/http"
require "json"

# Delete all data from the database
Review.destroy_all
User.destroy_all
Book.destroy_all
Author.destroy_all
Category.destroy_all
Publisher.destroy_all
SaleInfo.destroy_all

# Reset the auto-Increment counter for the primary key.
tables_to_reset = ["reviews", "users", "authors", "categories", "books", "publishers", "sale_infos"]
tables_to_reset.each do |table_name|
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='#{table_name}';")
end

# Getting data from Google Books API with multiple requests.
books_requests = [
  { key_word: "php", number: 40 },
  { key_word: "java", number: 40 },
  { key_word: "javascript", number: 40 },
  { key_word: "C++", number: 40 },
  { key_word: "C#", number: 40 },
  { key_word: "ruby", number: 40 },
  { key_word: "windows", number: 40 },
  { key_word: "linux", number: 40 }
]

books_requests.each do |request|
  # API call
  url = "https://www.googleapis.com/books/v1/volumes?q=#{request[:key_word]}&maxResults=#{request[:number]}&startIndex=1&key=AIzaSyBBpF7YQ9jXL5I3ZHDJVLCVoxx7qBaNJ1w"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)
  books_data = data ["items"]

  puts "\nThe are #{books_data.count} books for '#{request[:key_word]}'"

  books_data.each do |element|
    # If book does not have a ISBN, skip it
    isbn = element["volumeInfo"]["industryIdentifiers"]&.dig(0, "identifier")
    if isbn.nil?
      puts "Book uniqueness can't be validated (no ISBN), skipping..."
      next
    end

    # If book is a duplicate, skip it
    book_record = Book.find_by(isbn:)
    unless book_record.nil?
      puts "Book already exists, skipping..."
      next
    end

    # Publisher
    publisher_name = element["volumeInfo"]&.dig("publisher")

    publisher = publisher_name.present? ? Publisher.find_or_create_by(name: publisher_name) : nil

    # SaleInfo
    sale_info = SaleInfo.create(
      price:    element["saleInfo"]&.dig("listPrice", "amount"),
      currency: element["saleInfo"]&.dig("listPrice", "currencyCode"),
      buy_link: element["saleInfo"]&.dig("buyLink")
    )

    # Books
    book = Book.create(
      title:                 element["volumeInfo"]["title"],
      publisher:,
      published_date:        element["volumeInfo"]["publishedDate"],
      description:           element["volumeInfo"]["description"],
      isbn:                  element["volumeInfo"]["industryIdentifiers"]&.dig(0, "identifier"),
      page_count:            element["volumeInfo"]&.dig("pageCount"),
      language:              element["volumeInfo"]["language"],
      image_small_thumbnail: element["volumeInfo"]["imageLinks"]&.dig("smallThumbnail"),
      image_thumbnail:       element["volumeInfo"]["imageLinks"]&.dig("thumbnail"),
      preview_link:          element["volumeInfo"]["previewLink"],
      sale_info:,
      search_info:           element["searchInfo"]&.dig("textSnippet")
    )

    # Authors
    authors = element["volumeInfo"]["authors"]
    if authors.present?
      authors.each do |author_name|
        author = Author.find_or_create_by(
          name: author_name
        )

        author.books << book
      end
    end

    # Categories
    categories = element["volumeInfo"]["categories"]
    if categories.present?
      categories.each do |category_name|
        category = Category.find_or_create_by(
          name: category_name
        )

        category.books << book
      end
    end

    # Console feedback
    if book.errors.any?
      puts book.errors.full_messages
    else
      puts "Created book #{book.title}"
    end
  end
end

# Use Faker to create 50 users (username, email, first name, last name)
user_amount = 50

user_amount.times do
  User.create(
    username:   Faker::Internet.unique.username,
    email:      Faker::Internet.unique.email,
    first_name: Faker::Name.first_name,
    last_name:  Faker::Name.last_name
  )
end

# Create 200 ratings. Random user_id, random book_id, random rating 1-5, Faker comment string.
review_amount = 200

review_amount.times do
  Review.create(
    user_id: rand(1..User.count),
    book_id: rand(1..Book.count),
    rating:  rand(1..5),
    comment: Faker::Quotes::Shakespeare.as_you_like_it_quote
  )
end
