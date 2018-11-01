Rails.application.routes.draw do

  root 'static_pages#home'
  get '/help',to: 'static_pages#help'
  get '/about',to: 'static_pages#about'

  # get '/user/:id',to: 'users#show' ,as: 'user'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users ,only: [:show,:index]
  resources :blogs do
    resources :entries,only: [:new,:create]
  end
  resources :entries,only: [:show,:edit,:update,:destroy] do
    resources :comments,only: [:create]
  end
  resources :comments,only: [:destroy,:update]
end
