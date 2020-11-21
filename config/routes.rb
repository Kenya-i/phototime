Rails.application.routes.draw do
  root 'home#top'
  # get 'home/top'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/about",   to: "home#about"
  get "/contact", to: "home#contact"
  get "/signup",  to: "users#new"
  resources :users


end