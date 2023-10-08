require "faker"
require "net/http"
require "json"

# Delete all data from the database.
Review.delete_all
User.delete_all
Author.delete_all
Category.delete_all
Book.delete_all
Publisher.delete_all
SaleInfo.delete_all

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
  url = "https://www.googleapis.com/books/v1/volumes?q=#{request[:key_word]}&maxResults=#{request[:number]}&startIndex=1&key=AIzaSyBBpF7YQ9jXL5I3ZHDJVLCVoxx7qBaNJ1w"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)
  books_data = data ["items"]

  puts "The are #{books_data.count} books for '#{request[:key_word]}'"

  books_data.each do |element|
    # Publisher
    publisher_name = element["volumeInfo"]["publisher"]
    publisher = publisher_name.present? ? Publisher.find_or_create_by(name: publisher_name) : nil

    # SaleInfo
    sale_info = SaleInfo.create(
      price:    element["saleInfo"]&.dig("listPrice", "amount"),
      currency: element["saleInfo"]&.dig("listPrice", "currencyCode"),
      buy_link: element["saleInfo"]&.dig("buyLink")
    )

    # Authors
    authors = element["volumeInfo"]["authors"]
    if authors.present?
      authors.each do |author|
        Author.find_or_create_by(
          name: author
        )
      end
    end

    # Categories
    categories = element["volumeInfo"]["categories"]
    if categories.present?
      categories.each do |category|
        Category.find_or_create_by(
          name: category
        )
      end
    end

    # Books
    Book.create(
      title:                 element["volumeInfo"]["title"],
      publisher:,
      published_date:        element["volumeInfo"]["publishedDate"],
      description:           element["volumeInfo"]["description"],
      isbn:                  element["volumeInfo"]["industryIdentifiers"]&.dig(0, "identifier"),
      page_count:            element["volumeInfo"]["pageCount"],
      language:              element["volumeInfo"]["language"],
      image_small_thumbnail: element["volumeInfo"]["imageLinks"]&.dig("smallThumbnail"),
      image_thumbnail:       element["volumeInfo"]["imageLinks"]&.dig("thumbnail"),
      preview_link:          element["volumeInfo"]["previewLink"],
      sale_info:,
      search_info:           element["searchInfo"]&.dig("textSnippet")
    )
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
