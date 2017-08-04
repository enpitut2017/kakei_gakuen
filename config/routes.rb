Rails.application.routes.draw do

  resources :books
  resources :users

  get  '/login',  to: 'static_page#login'

  root 'static_page#index'

  #root 'users#show'

  #get 'book#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
