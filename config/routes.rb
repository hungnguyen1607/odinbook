Rails.application.routes.draw do
  devise_for :users
  
  root "posts#index"

  resources :posts, only: [:index, :show, :new, :create, :destroy, :edit, :update] do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end

  resources :friendships, only: [:index, :create, :update, :destroy]
  resources :users, only: [:index, :show], path: 'members'
end