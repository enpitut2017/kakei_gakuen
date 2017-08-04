Rails.application.routes.draw do


  resources :books
  resources :users

  get   '/signup',  to:'users#new'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get 'static_page/index'

  root 'static_page#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
