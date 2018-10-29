Rails.application.routes.draw do
  root 'static_pages#home'
  resources :blogs do
    resources :entries,only: [:new,:create]
  end
  resources :entries,only: [:show,:edit,:update,:destroy] do
    resources :comments,only: [:create]
  end
  resources :comments,only: [:destroy,:update]
end
