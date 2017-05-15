Rails.application.routes.draw do

  devise_for :users
  # ============== Active admin and Devise ================= #
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # ======================================================== #
  resources :categories
  resources :items
  resources :carts

end
