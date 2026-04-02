Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root 'pages#home'

  get '/about', to: 'pages#about', as: 'about'
  get '/contact', to: 'pages#contact', as: 'contact'

  resources :books, only: [:index, :show]
  resources :categories, only: [:index, :show]

  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end