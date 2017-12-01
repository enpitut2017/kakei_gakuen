Rails.application.routes.draw do

  get 'admin_custom_controller/new'

  devise_for :admin_users, ActiveAdmin::Devise.config
  get "/managers_login", to: 'managers#new'
  post "/managers_login", to: 'managers#create'
  get"/managers_logout", to: 'managers#destroy'



  ActiveAdmin.routes(self)
    root 'static_page#index'

    #books
    resources :books
    resources :saves

    #saves
    post '/saves/update', to: 'saves#update'

    #users
    resources :users, :except => [:edit, :update, :new, :destroy] do
        member do
            get 'profile_edit'
            patch 'profile_update'
            put 'profile_update'

            get 'budget_edit'
            patch 'budget_update'
            put 'budget_update'
        end
    end

    get   '/signup',  to:'users#new'
    get   '/retire',  to: 'users#destroy'
    get   '/image',  to:'users#image'

    #closets
    get   '/closets', to:'closets#edit'
    post  '/closets', to:'closets#update'

    #sessions
    get   '/login',   to: 'sessions#new'
    post  '/login',   to: 'sessions#create'
    get   '/logout',  to: 'sessions#destroy'

    #error
    get '/error_403', to: 'error#error_403'
    get '/error_404', to: 'error#error_404'
    get '/error_500', to: 'error#error_500'

    #api
    #constraints subdomain: 'api' do
    #    api.sample.com
    #    resources :books
    #    resources :users
    #end

    #resource :api do
    #    resources :books
    #    resources :users
    #end

    get '/api/image/:token', to: 'api#image'
    post '/api/login/', to: 'api#login'
    post '/api/create/', to: 'api#create'
    post '/api/books/', to: 'api#register_books'

    #static_page
    get 'static_page/index'
    get '/index.html', to:'static_page#index'

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get '*path', to: 'application#error_404'
    end
