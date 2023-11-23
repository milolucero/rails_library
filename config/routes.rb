Rails.application.routes.draw do
  get 'cart/index'
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
  get "/cart", to: "cart#index", as: "cart"
  post "books/add_to_cart", to: "books#add_to_cart", as: "add_to_cart"
  post 'books/update_quantity', to: 'books#update_quantity', as: 'update_quantity'
  delete "books/remove_from_cart", to: "books#remove_from_cart", as: "remove_from_cart"

  # Categories
  get "/categories", to: "categories#index"
  get "/categories/:category_name", to: "categories#show"

  # About
  get "/about", to: "about#index"
end
