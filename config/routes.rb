Rails.application.routes.draw do
  resources :activities
  devise_for :users
  resources :routines

  root 'routine#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
