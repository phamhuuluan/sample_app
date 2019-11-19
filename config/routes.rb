Rails.application.routes.draw do
  root to: "static_pages#home"

  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  
  resources :users
  resources :account_activations, only: %i(edit)
  resources :password_resets, except: %i(index show destroy)
  resources :microposts, only: %i(create destroy)
  resources :password_resets, except: %i(index show destroy)
  resources :relationships, only: %i(create destroy)
  resources :followings, only: :index
  resources :followers, only: :index
end
