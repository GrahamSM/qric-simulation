Rails.application.routes.draw do

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/users' => 'users#show'

  resources :trade_requests

  get "accept/:id" => "trade_requests#accept", :as => "accept"

  resources :teams

  resources :properties
  get "develop/:id" => "users#develop", :as => "develop"

  resources :incentives

  namespace :admin do
    resources :properties do
      collection do
        get 'shock1'
        get 'shock2'
        get 'shock3'
        get 'shock4'
        get 'shock5'
        get 'end_game'
        get 'change_team'
      end
    end
  end

  root "sessions#new"

end
