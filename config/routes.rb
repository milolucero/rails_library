Rails.application.routes.draw do
  get 'orders/index'
  get 'orders/show'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
  }

  get 'pages/show'
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

  # Checkout
  scope '/cart' do
    get 'checkout', to: 'checkout#index', as: 'checkout'
  end

  scope '/checkout' do
    post 'create',      to: 'checkout#create',      as: 'checkout_create'
    get  'cancel',      to: 'checkout#cancel',      as: 'checkout_cancel'
    get  'pre_success', to: 'checkout#pre_success', as: 'checkout_pre_success'
    get  'success',     to: 'checkout#success',     as: 'checkout_success'
    post 'update_user_address', to: 'checkout#update_user_address'
  end

  # Categories
  get "/categories", to: "categories#index"
  get "/categories/:category_name", to: "categories#show"

  # About & Contact pages
  get "pages/:slug", to: 'pages#show', as: 'regular_page'

  # Users
  resource :user, only: [:update]

  resources :users do
    resources :orders, only: %i[index show create]
  end
end
