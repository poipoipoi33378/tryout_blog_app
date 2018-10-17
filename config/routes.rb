Rails.application.routes.draw do
  root 'blogs#index'
  resources :blogs do
    resources :entries,except: [:destroy]
  end
  resources :entries,only: [:destroy]


end
