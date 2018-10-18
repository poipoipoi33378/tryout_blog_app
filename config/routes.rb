Rails.application.routes.draw do
  root 'blogs#index'
  resources :blogs do
    resources :entries,except: [:destroy,:index]
  end
  resources :entries,only: [:destroy] do
    resources :comments,only: [:create]
  end
  resources :comments,only: [:destroy,:edit]
end
