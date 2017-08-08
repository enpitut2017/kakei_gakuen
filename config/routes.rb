Rails.application.routes.draw do

  resources :books
  resources :users

  get   '/signup',  to:'users#new'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get   '/logout',  to: 'sessions#destroy'

  get   '/retire',  to: 'users#destroy'

  constraints subdomain: 'api' do
    # api.sample.com
    resources :books
    resources :users
  end

  resource :api do
    resources :books
    resources :users
  end

  get 'static_page/index'

  root 'static_page#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '*path', to: 'application#error_404'
end
