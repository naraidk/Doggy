Rails.application.routes.draw do
  get "ai_messages/create"
  get "ai_chats/show"
  get "ai_chats/new"
  get "ai_chats/create"
  get "messages/create"
  get "conversations/index"
  get "conversations/show"
  get "conversations/new"
  get "conversations/create"
  get "event_participants/create"
  get "event_participants/destroy"
  get "events/index"
  get "events/show"
  get "events/new"
  get "events/create"
  get "events/edit"
  get "events/update"
  get "events/destroy"
  get "woufs/create"
  get "woufs/destroy"
  get "comments/create"
  get "comments/destroy"
  get "posts/index"
  get "posts/show"
  get "posts/new"
  get "posts/create"
  get "posts/edit"
  get "posts/update"
  get "posts/destroy"
  get "dogs/index"
  get "dogs/show"
  get "dogs/new"
  get "dogs/create"
  get "dogs/edit"
  get "dogs/update"
  get "dogs/destroy"
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
  resources :dogs do
    resources :conversations, only: [:create]
  end

  resources :conversations, only: [:show] do
    resources :messages, only: [:create]
  end
end
