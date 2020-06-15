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
    resources :participations, except: [:show, :new, :edit]
  end


  #Routes for chats (and messages)
  resources :chats, except: [:new, :edit, :update, :destroy] do
    resources :messages, except: [:show, :new, :edit, :update, :destroy]
  end


  #Routes for flags
  resources :flags, except: [:edit, :update]


  #REST API RESOURCES
  # TODO non dovremmo metterci anche le chat, messaggi e pages?
  namespace :api, defaults: { format: "json" } do
    resources :users, only: [:show] do
      resources :follows, except: [:show, :new, :edit, :update]
    end

    resources :tags, except: [:index, :show, :new, :edit, :update]

    resources :events, except: [:index] do
      resources :comments, except: [:index, :show, :new, :edit]
      resources :participations, except: [:show, :new, :edit]
    end
    
    resources :flags, except: [:edit, :update]
  end

end
