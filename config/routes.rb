Rails.application.routes.draw do

  root 'items#index'

  # ============== Active admin and Devise ================= #

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users
  # ======================================================== #
  resources :categories
  resources :items

  post '/cart', to: 'users#cart', as: 'user_cart'
  get '/cart', to: 'users#cart', as: 'show_user_cart'
  delete '/cart/:id', to: 'users#remove_cart_item', as: 'remove_cart_item'

  post '/order', to: 'users#order', as: 'order'
end
