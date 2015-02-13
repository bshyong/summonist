require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: {format: :json},
                  # constraints: { subdomain: 'api'},
                  path: '/' do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:index, :show, :update, :create]
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
    end
  end
end
