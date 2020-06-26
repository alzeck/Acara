Rails.application.routes.draw do

  default_url_options :host => "localhost:3000"


  #Routes linked to users
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show] do
    resources :follows, except: [:show, :new, :edit, :update]
  end


  #Routes for tags
  resources :tags, except: [:index, :show, :new, :edit, :update]


  #Routes for the pages (home, search)
  root to: "pages#home"
  get "/search", to: "pages#search", as: "search"


  #Routes for events (and comments, and participations)
  resources :events, except: [:index] do
    resources :comments, except: [:index, :show, :new, :edit]
    resources :participations, except: [:index, :show, :new, :edit]
  end


  #Routes for chats (and messages)
  resources :chats, except: [:new, :edit, :update, :destroy] do
    resources :messages, only: [:create]
  end


  #Routes for flags
  resources :flags, only: [:new, :create]


  #REST API RESOURCES
  namespace :api, defaults: { format: "json" } do
    resources :users, only: [:index, :show]

    resources :events, except: [:new, :edit] do
      resources :comments, except: [:new, :edit]
    end
  end

end
