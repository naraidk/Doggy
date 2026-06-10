Rails.application.routes.draw do
  get "swipes/index"
  get "swipes/create"
  devise_for :users


  root to: "posts#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # DOGS + CHATBOT IA
  resources :dogs do
    member do
      get :edit_avatar
    end
    resources :ai_chats, only: [:index, :show, :create] do
      resources :ai_messages, only: [:create]
    end
  end

  # changer de chien
  post "select_dog/:dog_id", to: "dogs#select", as: :select_dog


   # CONVERSATIONS ENTRE CHIENS
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  # FEED (posts, comments, woufs)
  resources :posts, only: [:index, :new, :create, :show, :destroy] do
    resources :woufs, only: [:create, :destroy]
    resources :comments, only: [:index, :create, :destroy]
  end

# Pop up de post
  resources :posts do
    member do
      get :post_panel
    end
  end



  # EVENTS
  resources :events do
    resources :event_participants, only: [:create, :destroy]
  end

  # MAP
  get "map" => "maps#index", as: :map

  #MATCHING
  # MATCHING
  resources :swipes, only: [:index, :create] do
    collection do
      post :undo
      get :liked
    end
  end
end
