Rails.application.routes.draw do

  root 'home#top'
  get "/about",   to: "home#about"
  get "/help", to: "home#help"
  get "/contact", to: "home#contact"
  get "/terms", to: "home#terms"
  get "/signup",  to: "users#new"
  get "/signup", to: "users#create"
  get '/login', to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/search", to: "posts#search"

  resources :users, except: [:new, :create]

  resources :users do
    resource :password, except: [:index, :create, :new, :show , :destroy]
    resource :following, only: [:show]
    resource :follower, only: [:show]
    # member do
    #   get :following, :followers
    # end
  end

  resources :posts, except: [:index, :destroy] do
    resource :comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]

  resources :notifications, only: :index

end