Rails.application.routes.draw do
  root 'blogs#index'
  resources :blogs do
    resources :entries,except: [:destroy]
  end
  resources :entries,only: [:destroy] do
    resources :comments,only: [:create]
  end
  resources :comments,only: [:destroy]
end
