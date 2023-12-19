# BookHub E-Commerce Platform

<img src="app/assets/images/bookhub_logo.svg" alt="BookHub logo" width="300">

BookHub is a user-friendly e-commerce web platform developed with Ruby on Rails, originally conceptualized as a college project. This platform allows book enthusiasts to explore a vast collection of books, view detailed information about each book, and seamlessly add their favourites to a shopping cart for purchase.

## Key Features:

- **User Authentication:** Users can create and manage an account to keep track of their orders.
- **Google Books API Integration:** Utilizes the Google Books API to populate the platform's database with a vast collection of books, ensuring an extensive and up-to-date library for users to explore.
- **Browsing Books:** Users can effortlessly browse, search, and filter through a wide selection of books and categories available on the platform.
- **Shopping Cart:** Easy management of selected books in a user's shopping cart for convenient checkout.
- **Secure Payments:** Integration with Stripe for secure and reliable payment processing.
- **Administrative Platform:** An interface for administrative users to manage settings, control data, and oversee the platform's functionality.

## Database Entity-Relationship Diagram (ERD)

![Database ERD](db/erd.png)

Here is the visual representation of the database structure in BookHub. This diagram illustrates the relationships between various entities and their attributes within the database.

## Installation

### Requirements
- Docker: The application is containerized using Docker. If you don't have Docker installed, you can download it from [here](https://www.docker.com/products/docker-desktop).

To get started with BookHub, follow these simple steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/milolucero/rails_library.git
   cd rails_library
   ```

2. Build the Docker image:

   ```bash
   docker build -t rails_library .
   ```

3. Create a .env file in the root directory of the project. This file should contain your Stripe keys for the checkout functionality. If you don't have a Stripe account, you can create one for free [here](https://dashboard.stripe.com/register).

   The .env file should follow the format found in the .env-sample file:

   ```bash
   # Stripe keys
   PUBLISHABLE_KEY=your_publishable_key
   SECRET_KEY=your_secret_key
   ```

   Replace your_publishable_key and your_secret_key with your actual Stripe keys.

4. Run the Docker container:

   ```bash
   docker run --env-file .env -it --rm -p 3000:3000 rails_library
   ```

Once the server is up and running, you can access BookHub by visiting [http://localhost:3000](http://localhost:3000) in your web browser.

## Additional notes

**To access the administrative platform**

1. Log in as an administrative user
   - Username: `admin@bookhub.com`
   - Password: `password`
2. Visit [http://localhost:3000/admin](http://localhost:3000/admin).

**To complete a purchase**

1. Run the platform running with Stripe checkout enabled.
2. When entering payment details use:
   - **Credit card number:** `4242 4242 4242 4242`
   - **Expiration date:** Any future date, such as `12/34`
   - **CVV number:** Any 3-digit number
   - Use any value you like for other form fields

## Preview

### Home Page

![Homepage](app/assets/images/preview/homepage.png)

### Book details

![Homepage](app/assets/images/preview/book_details.png)

### Checkout

![Homepage](app/assets/images/preview/checkout.png)
