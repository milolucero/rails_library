Rails.application.routes.draw do
  # Root
  root "books#index"

  # Books
  resources :books, only: [:index, :show]

  # Categories
  get "/categories", to: "categories#index"
  get "/categories/:category_name", to: "categories#show"

  # About
  get "/about", to: "about#index"
end
