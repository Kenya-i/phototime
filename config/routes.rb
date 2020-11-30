Rails.application.routes.draw do
  root 'home#top'
  # get 'home/top'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/about",   to: "home#about"
  get "/help", to: "home#help"
  get "/contact", to: "home#contact"

  get "/signup",  to: "users#new"
  get "/signup", to: "users#create"


  get '/login', to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users
  # get "/users/:id/edit/password", to: ""
  # resources :users do
  #   resource :password, except: [:index, :create, :new, :show]
  # end

  resources :posts

  get "/users/:id/password/edit", to: "passwords#edit"
  patch "/users/:id/password",  to: "passwords#update"
  delete "/users/:id/password", to: "passwords#destroy"

end