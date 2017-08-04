Rails.application.routes.draw do
  get 'static_page/index'

  resources :books
  resources :users

  root 'static_page#index'

  #root 'users#show'

  #get 'book#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
