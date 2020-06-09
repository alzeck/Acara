Rails.application.routes.draw do
  default_url_options :host => "localhost:3000"

  root to: 'pages#home'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #Crud events for Resources
  resources :events, except: [:index]
  resources :chat, except: [:edit, :update]
  resources :comments, except: [:index, :new]
  resources :flags, except: [:edit, :update]
  resources :follows, except: [:edit,:show,:update]
  resources :messages, except: [:index,:edit,:update,:destroy]
  resources :participations, except: [:index, :new, :edit, :show]

end
