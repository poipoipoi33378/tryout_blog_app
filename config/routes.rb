Rails.application.routes.draw do
  root 'blogs#index'
  get '/index',to:'blogs#index'
  resources :blogs
end
