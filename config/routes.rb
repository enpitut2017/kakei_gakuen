Rails.application.routes.draw do


  resources :books
  resources :users

  #get  '/login',  to: 'static_page#login'

  get   '/signup',  to:'users#new'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  root 'static_page#index'

  #root 'users#show'

  #get 'book#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
