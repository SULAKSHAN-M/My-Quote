Rails.application.routes.draw do
  # Public homepage
  root "pages#home"

  # Session routes (login/logout)
  get    "/login",   to: "sessions#new",     as: :login
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy", as: :logout

  # User registration and profile
  get  "/signup",          to: "users#new",    as: :signup
  post "/signup",          to: "users#create"
  get  "/profile",         to: "users#show",   as: :profile
  get  "/profile/edit",    to: "users#edit",   as: :edit_profile
  patch "/profile",        to: "users#update"
  get  "/profile/password", to: "users#edit_password", as: :edit_password
  patch "/profile/password", to: "users#update_password"

  # Admin namespace
  namespace :admin do
    get "/", to: "dashboard#index", as: :dashboard
    resources :users, only: [:index, :show, :edit, :update, :destroy]
  end

  # Sources (philosophers)
  resources :sources

  # Categories
  resources :categories

  # Quotes
  resources :quotes

  # Public category search
  get "/search", to: "pages#search", as: :search
end
