require "faker"
require "net/http"
require "json"

# To do: Delete all data from the database
Review.delete_all
User.delete_all
Author.delete_all
Category.delete_all
Book.delete_all
Publisher.delete_all
SaleInfo.delete_all

ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='reviews';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='users';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='authors';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='categories';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='books';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='publishers';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='sale_infos';")

# Getting data from Google Books API
url = "https://www.googleapis.com/books/v1/volumes?q=education&maxResults=40&startIndex=1&key=AIzaSyBBpF7YQ9jXL5I3ZHDJVLCVoxx7qBaNJ1w"
uri = URI(url)
response = Net::HTTP.get(uri)
data = JSON.parse(response)
books_data = data ["items"]
puts "The is #{books_data.count} books"

# dummy_google_data = [
#   # Book 1
#   {
#     "kind":       "books#volume",
#     "id":         "nWXSBwAAQBAJ",
#     "etag":       "9dAbB0ojfpk",
#     "selfLink":   "https://www.googleapis.com/books/v1/volumes/nWXSBwAAQBAJ",
#     "volumeInfo": {
#       "title":               "Computer Network Architectures and Protocols",
#       "authors":             [
#         "Paul Greens",
#         "Anthony Oliver"
#       ],
#       "publisher":           "Springer Science & Business Media",
#       "publishedDate":       "2012-12-06",
#       "description":         "This is a book about the bricks and mortar out of which are built those edifices that so well characterize late twentieth century industrial society networks of computers and terminals. Such computer networks are playing an increasing role in our daily lives, somewhat indirectly up to now as the hidden servants of banks, retail credit bureaus, airline reservation offices, and so forth, but soon they will become more visible as they enter our offices and homes and directly become part of our work, entertainment, and daily living. The study of how computer networks work is a combined study of communication theory and computer science, two disciplines appearing to have very little in common. The modern communication scientist wishing to work in this area finds himself in suddenly unfamiliar territory. It is no longer sufficient for him to think of transmission, modulation, noise immun ity, error bounds, and other abstractions of a single communication link; he is dealing now with a topologically complex interconnection of such links. And what is more striking, solving the problems of getting the signal from one point to another is just the beginning of the communication process. The communication must be in the right form to be routed properly, to be handled without congestion, and to be understood at the right points in the network. The communication scientist suddenly finds himself charged with responsibility for such things as code and format conversions, addressing, flow control, and other abstractions of a new and challenging kind.",
#       "industryIdentifiers": [
#         {
#           "type":       "ISBN_13",
#           "identifier": "9781461566984"
#         },
#         {
#           "type":       "ISBN_10",
#           "identifier": "1461566983"
#         }
#       ],
#       "readingModes":        {
#         "text":  false,
#         "image": true
#       },
#       "pageCount":           719,
#       "printType":           "BOOK",
#       "categories":          [
#         "Technology & Engineering"
#       ],
#       "maturityRating":      "NOT_MATURE",
#       "allowAnonLogging":    false,
#       "contentVersion":      "1.1.1.0.preview.1",
#       "panelizationSummary": {
#         "containsEpubBubbles":  false,
#         "containsImageBubbles": false
#       },
#       "imageLinks":          {
#         "smallThumbnail": "http://books.google.com/books/content?id=nWXSBwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
#         "thumbnail":      "http://books.google.com/books/content?id=nWXSBwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
#       },
#       "language":            "en",
#       "previewLink":         "http://books.google.ca/books?id=nWXSBwAAQBAJ&printsec=frontcover&dq=computer&hl=&cd=25&source=gbs_api",
#       "infoLink":            "https://play.google.com/store/books/details?id=nWXSBwAAQBAJ&source=gbs_api",
#       "canonicalVolumeLink": "https://play.google.com/store/books/details?id=nWXSBwAAQBAJ"
#     },
#     "saleInfo":   {
#       "country":     "CA",
#       "saleability": "FOR_SALE_AND_RENTAL",
#       "isEbook":     true,
#       "listPrice":   {
#         "amount":       203.82,
#         "currencyCode": "CAD"
#       },
#       "retailPrice": {
#         "amount":       163.06,
#         "currencyCode": "CAD"
#       },
#       "buyLink":     "https://play.google.com/store/books/details?id=nWXSBwAAQBAJ&rdid=book-nWXSBwAAQBAJ&rdot=1&source=gbs_api",
#       "offers":      [
#         {
#           "finskyOfferType": 1,
#           "listPrice":       {
#             "amountInMicros": 203_820_000,
#             "currencyCode":   "CAD"
#           },
#           "retailPrice":     {
#             "amountInMicros": 163_060_000,
#             "currencyCode":   "CAD"
#           },
#           "giftable":        true
#         },
#         {
#           "finskyOfferType": 3,
#           "listPrice":       {
#             "amountInMicros": 71_340_000,
#             "currencyCode":   "CAD"
#           },
#           "retailPrice":     {
#             "amountInMicros": 64_210_000,
#             "currencyCode":   "CAD"
#           },
#           "rentalDuration":  {
#             "unit":  "DAY",
#             "count": 90
#           }
#         }
#       ]
#     },
#     "accessInfo": {
#       "country":                "CA",
#       "viewability":            "PARTIAL",
#       "embeddable":             true,
#       "publicDomain":           false,
#       "textToSpeechPermission": "ALLOWED",
#       "epub":                   {
#         "isAvailable": false
#       },
#       "pdf":                    {
#         "isAvailable":  true,
#         "acsTokenLink": "http://books.google.ca/books/download/Computer_Network_Architectures_and_Proto-sample-pdf.acsm?id=nWXSBwAAQBAJ&format=pdf&output=acs4_fulfillment_token&dl_type=sample&source=gbs_api"
#       },
#       "webReaderLink":          "http://play.google.com/books/reader?id=nWXSBwAAQBAJ&hl=&source=gbs_api",
#       "accessViewStatus":       "SAMPLE",
#       "quoteSharingAllowed":    false
#     },
#     "searchInfo": {
#       "textSnippet": "This is a book about the bricks and mortar out of which are built those edifices that so well characterize late twentieth century industrial society networks of computers and terminals."
#     }
#   },

#   # Book 2
#   {
#     "kind":       "books#volume",
#     "id":         "YqScEAAAQBAJ",
#     "etag":       "j1vyGljO0y8",
#     "selfLink":   "https://www.googleapis.com/books/v1/volumes/YqScEAAAQBAJ",
#     "volumeInfo": {
#       "title":               "Introduction to Computer Theory",
#       "authors":             [
#         "Daniel I. A. Cohen"
#       ],
#       "publisher":           "John Wiley & Sons",
#       "publishedDate":       "1996-10-25",
#       "description":         "This text strikes a good balance between rigor and an intuitive approach to computer theory. Covers all the topics needed by computer scientists with a sometimes humorous approach that reviewers found \"refreshing\". It is easy to read and the coverage of mathematics is fairly simple so readers do not have to worry about proving theorems.",
#       "industryIdentifiers": [
#         {
#           "type":       "ISBN_13",
#           "identifier": "9780471137726"
#         },
#         {
#           "type":       "ISBN_10",
#           "identifier": "0471137723"
#         }
#       ],
#       "readingModes":        {
#         "text":  false,
#         "image": true
#       },
#       "pageCount":           661,
#       "printType":           "BOOK",
#       "categories":          [
#         "Computers"
#       ],
#       "maturityRating":      "NOT_MATURE",
#       "allowAnonLogging":    false,
#       "contentVersion":      "preview-1.0.0",
#       "panelizationSummary": {
#         "containsEpubBubbles":  false,
#         "containsImageBubbles": false
#       },
#       "imageLinks":          {
#         "smallThumbnail": "http://books.google.com/books/content?id=YqScEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
#         "thumbnail":      "http://books.google.com/books/content?id=YqScEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
#       },
#       "language":            "en",
#       "previewLink":         "http://books.google.ca/books?id=YqScEAAAQBAJ&printsec=frontcover&dq=computer&hl=&cd=34&source=gbs_api",
#       "infoLink":            "http://books.google.ca/books?id=YqScEAAAQBAJ&dq=computer&hl=&source=gbs_api",
#       "canonicalVolumeLink": "https://books.google.com/books/about/Introduction_to_Computer_Theory.html?hl=&id=YqScEAAAQBAJ"
#     },
#     "saleInfo":   {
#       "country":     "CA",
#       "saleability": "NOT_FOR_SALE",
#       "isEbook":     false
#     },
#     "accessInfo": {
#       "country":                "CA",
#       "viewability":            "PARTIAL",
#       "embeddable":             true,
#       "publicDomain":           false,
#       "textToSpeechPermission": "ALLOWED",
#       "epub":                   {
#         "isAvailable": false
#       },
#       "pdf":                    {
#         "isAvailable":  true,
#         "acsTokenLink": "http://books.google.ca/books/download/Introduction_to_Computer_Theory-sample-pdf.acsm?id=YqScEAAAQBAJ&format=pdf&output=acs4_fulfillment_token&dl_type=sample&source=gbs_api"
#       },
#       "webReaderLink":          "http://play.google.com/books/reader?id=YqScEAAAQBAJ&hl=&source=gbs_api",
#       "accessViewStatus":       "SAMPLE",
#       "quoteSharingAllowed":    false
#     },
#     "searchInfo": {
#       "textSnippet": "This text strikes a good balance between rigor and an intuitive approach to computer theory."
#     }
#   }
# ]

books_data.each do |element|
  # Publisher
  publisher = Publisher.find_or_create_by(
    name: element["volumeInfo"]["publisher"]
  )

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
    isbn:                  element["volumeInfo"]["industryIdentifiers"][0]["identifier"],
    page_count:            element["volumeInfo"]["pageCount"],
    language:              element["volumeInfo"]["language"],
    image_small_thumbnail: element["volumeInfo"]["imageLinks"]["smallThumbnail"],
    image_thumbnail:       element["volumeInfo"]["imageLinks"]["thumbnail"],
    preview_link:          element["volumeInfo"]["previewLink"],
    sale_info:,
    search_info:           element["searchInfo"]
  )
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
