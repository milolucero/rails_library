Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Root
  root "books#index"

  # Books
  resources :books, only: %i[index show] do
    collection do
      get "search"
    end
  end

  # Cart
  post "books/add_to_cart/:id", to: "books#add_to_cart", as: "add_to_cart"
  delete "books/remove_from_cart/:id", to: "books#remove_from_cart", as: "remove_from_cart"

  # Categories
  get "/categories", to: "categories#index"
  get "/categories/:category_name", to: "categories#show"

  # About
  get "/about", to: "about#index"
end
