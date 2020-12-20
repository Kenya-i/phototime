Rails.application.routes.draw do
  # devise_for :users,
  # controllers: {
  #   sessions: 'users/sessions',
  #   registrations: "users/registrations",
  #   omniauth_callbacks: 'users/omniauth_callbacks'
  # }

  devise_for :users

  root 'home#top'
  # get 'home/top'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/about",   to: "home#about"
  get "/help", to: "home#help"
  get "/contact", to: "home#contact"
  get "/terms", to: "home#terms"

  get "/signup",  to: "users#new"
  get "/signup", to: "users#create"
  resources :users, except: [:new, :create]

  get '/login', to: "sessions#new"
  post "/login", to: "sessions#create"

  delete "/logout", to: "sessions#destroy"

  resources :users do
    resource :password, except: [:index, :create, :new, :show , :destroy]
    member do
      get :following, :followers
    end
  end

  # resources :users do
    # member do
    #   get :following, :followers
    # end
  # end

  

  # destroyなし
  # resources :posts, except: [:destroy]

  resources :posts, except: [:index, :destroy] do
    resource :comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
  end

  # resources :posts, only: [:index, :show, :create] do
  #   resources :likes, only: [:create, :destroy]
  # end


  resources :relationships, only: [:create, :destroy]

  get "/search", to: "posts#search"

  resources :notifications, only: :index

  # get "/users/:id/password/edit", to: "passwords#edit"
  # patch "/users/:id/password",  to: "passwords#update"
  # delete "/users/:id/password", to: "passwords#destroy"

end