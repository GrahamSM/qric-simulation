Rails.application.routes.draw do

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/users' => 'users#show'

  # get '/incentives' => 'incentives#index' TODO: Do we need this in the db?

  resources :trade_requests
  get '/trading' => 'trade_requests#home'
  get "accept/:id" => "trade_requests#accept", :as => "accept"


  resources :teams
  # get '/teams' => 'teams#index'

  resources :properties

  root "welcome#home"



end
