Rails.application.routes.draw do
  # Root
  root "books#index"

  # Books
  resources :books, only: [:index, :show]

  # Categories
  get "/:category", to: "category#index"

  # About
  get "/about", to: "about#index"
end
