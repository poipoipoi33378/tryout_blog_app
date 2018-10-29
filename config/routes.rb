Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#home'
  get '/help',to: 'static_pages#help'
  get '/about',to: 'static_pages#about'

  resources :blogs do
    resources :entries,only: [:new,:create]
  end
  resources :entries,only: [:show,:edit,:update,:destroy] do
    resources :comments,only: [:create]
  end
  resources :comments,only: [:destroy,:update]
end
