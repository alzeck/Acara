Rails.application.routes.draw do
  default_url_options :host => "localhost:3000"

  root to: "pages#home"
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show] do
    resources :follows, except: [:show, :new, :edit, :update]
  end

  # TODO decidere e gestire le routes per il controller pages (home, cerca...)

  #Crud routes for events (and comments, and participations)
  resources :events, except: [:index] do
    resources :comments, except: [:show, :new, :edit]
    resources :participations, except: [:show, :new, :edit]
  end

  #Crud routes for chats (and messages)
  resources :chats, except: [:new, :edit, :update, :destroy] do
    resources :messages, except: [:show, :new, :edit, :update, :destroy]
  end

  #Crud routes for flags
  resources :flags, except: [:edit, :update]

  # REST API RESOURCES 
  namespace :api, defaults: { format: "json" } do
    resources :users, only: [:show] do
      resources :follows, except: [:show, :new, :edit, :update]
    end

    # Crud routes for events (and comments, and participations)
    resources :events, except: [:index, :new, :edit] do
      resources :comments, except: [:show, :new, :edit]
      resources :participations, except: [:show, :new, :edit]
    end
    
    # Crud routes for flags
    resources :flags, except: [:edit, :update]
  end
end
