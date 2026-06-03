Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # FEED (posts, comments, woufs)
  resources :posts, only: [:index, :new, :create] do
    resources :woufs, only: [:create, :destroy]
    resources :comments, only: [:index, :create]
  end

    # DOGS
  resources :dogs

  # EVENTS
  resources :events do
    resources :event_participants, only: [:create, :destroy]
  end

  # CONVERSATIONS ENTRE CHIENS
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  # CHATBOT IA
  resources :ai_chats, only: [:index, :show, :create] do
    resources :ai_messages, only: [:create]
  end

end
