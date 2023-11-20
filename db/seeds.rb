require "faker"
require "net/http"
require "json"
Faker::Config.locale = "en-CA"

# Delete all data from the database
Review.destroy_all
BookOrder.destroy_all
BookCategory.destroy_all
BookAuthor.destroy_all
Order.destroy_all
User.destroy_all
Province.destroy_all
Book.destroy_all
Author.destroy_all
Category.destroy_all
Publisher.destroy_all
# SaleInfo.destroy_all

# Reset the auto-Increment counter for the primary key.
tables_to_reset = [
  "reviews",
  "users",
  "authors",
  "categories",
  "book_categories",
  "books",
  "publishers",
  "provinces",
  "orders",
  "book_orders",
  "book_authors"
]

tables_to_reset.each do |table_name|
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='#{table_name}';")
end

# Getting data from Google Books API with multiple requests.
books_requests = [
  { key_word: "computers", number: 40 },
  { key_word: "biography", number: 40 },
  { key_word: "fiction", number: 40 },
  { key_word: "education", number: 40 },
  { key_word: "art", number: 40 },
  { key_word: "sports", number: 40 },
  { key_word: "travel", number: 40 }
]

books_requests.each do |request|
  # API call
  url = "https://www.googleapis.com/books/v1/volumes?q=#{request[:key_word]}&maxResults=#{request[:number]}&startIndex=1&printType=books&key=AIzaSyBBpF7YQ9jXL5I3ZHDJVLCVoxx7qBaNJ1w"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)
  books_data = data ["items"]

  puts "\nThe are #{books_data.count} books for '#{request[:key_word]}'"

  books_data.each do |element|
    # Book's attributes
    publisher_name = element["volumeInfo"]&.dig("publisher")
    description = element["volumeInfo"]["description"]
    isbn = element["volumeInfo"]["industryIdentifiers"]&.dig(0, "identifier")
    page_count = element["volumeInfo"]["pageCount"]
    authors = element["volumeInfo"]["authors"]
    categories = element["volumeInfo"]["categories"]
    price = Float(Faker::Commerce.price(range: 5..100.0, as_string: true))

    book_attributes = [publisher_name, description, isbn, page_count, authors, categories,
                       price]

    # Check if any of the attributes is null or equal zero then skip this book
    if book_attributes.any? { |attribute| attribute.nil? || attribute == 0 }
      puts "Skipping book due to nil or zero attribute"
      next
    end

    # Check for duplicate book by ISBN
    book_record = Book.find_by(isbn:)
    if book_record
      puts "Book with ISBN #{isbn} already exists, skipping..."
      next
    end

    # Create Publisher
    publisher = Publisher.find_or_create_by(name: publisher_name)

    # # Create Sale_Info
    # sale_info = SaleInfo.create(
    #   price:    element["saleInfo"]&.dig("listPrice", "amount"),
    #   currency: element["saleInfo"]&.dig("listPrice", "currencyCode"),
    #   buy_link: element["saleInfo"]&.dig("buyLink")
    # )
    # Create Book
    book = Book.create(
      title:                 element["volumeInfo"]["title"],
      publisher:,
      published_date:        element["volumeInfo"]["publishedDate"],
      description:,
      isbn:,
      page_count:,
      language:              element["volumeInfo"]["language"],
      image_small_thumbnail: element["volumeInfo"]["imageLinks"]&.dig("smallThumbnail"),
      image_thumbnail:       element["volumeInfo"]["imageLinks"]&.dig("thumbnail"),
      preview_link:          element["volumeInfo"]["previewLink"],
      search_info:           element["searchInfo"]&.dig("textSnippet"),
      price:,
      is_on_sale:            rand(10).zero?, # 1 in 10 chance for the book being on sale
      sale_price:            (0.5 * price).round(2)
    )

    # Create authors and categories as needed
    if authors.present?
      authors.each do |author_name|
        author = Author.find_or_create_by(name: author_name)
        author.books << book
      end
    end

    if categories.present?
      categories.each do |category_name|
        # replace spaces and commas with underscore and hyphen in category_name
        category = Category.find_or_create_by(name: category_name.gsub(" ", "_").gsub(",", "-"))
        category.books << book
      end
    end

    puts "Created book #{book.title}"
    # Console feedback
    puts book.errors.full_messages if book.errors.any?
  end
end

# Populate Provinces table
provinces_json_data = File.read(Rails.root.join("db/provinces.json"))
provinces = JSON.parse(provinces_json_data)

provinces.each do |province|
  Province.create!(
    name:              province["name"],
    name_abbreviation: province["name_abbreviation"],
    gst:               province["gst"],
    pst:               province["pst"],
    hst:               province["hst"]
  )
end

# Use Faker to create users (username, email, first name, last name)
user_amount = 50

user_amount.times do
  User.create!(
    username:    Faker::Internet.unique.username,
    email:       Faker::Internet.unique.email,
    password:    "password",
    first_name:  Faker::Name.first_name,
    last_name:   Faker::Name.last_name,
    address:     Faker::Address.street_address,
    city:        Faker::Address.city,
    province_id: rand(1..13),
    postal_code: Faker::Address.postcode
  )
end

# Use Faker to create ratings. Random user_id, random book_id, random rating 1-5, Faker comment string.
review_amount = 500

review_amount.times do
  Review.create(
    user_id: rand(1..User.count),
    book_id: rand(1..Book.count),
    rating:  rand(1..5),
    comment: Faker::Quotes::Shakespeare.as_you_like_it_quote
  )
end

# Create a fake order, bookorder, book, user
Order.create!(user_id: 1, subtotal: 100, purchase_gst: 0.05, purchase_pst: 0.07, purchase_hst: 0.0,
              status: "Pending")
BookOrder.create!(book_id: 1, order_id: 1, quantity: 2, purchase_price: 25)

Book.create!(title: "Book about  an advanture", publisher_id: 10, published_date: "20-12-2020",
             description: "The best book", isbn: "123456789", page_count: 100, language: "en", image_small_thumbnail: "", image_thumbnail: "", preview_link: nil, search_info: nil, price: 20.55, is_on_sale: true, sale_price: 0.2055)
User.create!(username: "cbrown", email: "c.brown@mail.com", password: "password", first_name: "Chris",
             last_name: "Brown", address: "123 Main Street", city: "Winnipeg", province_id: 4, postal_code: "R3P9N8")

# ActiveAdmin user to database
if Rails.env.development?
  AdminUser.create!(email: "admin@bookhub.com", password: "password",
                    password_confirmation: "password")
end
