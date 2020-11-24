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


end