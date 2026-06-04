Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # DOGS + CHATBOT IA
  resources :dogs do
    resources :ai_chats, only: [:show, :create] do
      resources :ai_messages, only: [:create]
    end
  end

   # CONVERSATIONS ENTRE CHIENS
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  # FEED (posts, comments, woufs)
  resources :posts, only: [:index, :new, :create] do
    resources :woufs, only: [:create, :destroy]
    resources :comments, only: [:index, :create]
  end

  # EVENTS
  resources :events do
    resources :event_participants, only: [:create, :destroy]
  end

  # MAP
  get "map" => "maps#index", as: :map
end
