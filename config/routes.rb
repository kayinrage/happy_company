HappyCompany::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users

  root to: "home#index"

  namespace :user do
    root to: "home#index"
    resources :answers, only: [:index, :update]
    resource :profile, only: [:edit, :update], controller: "profile"
  end

  namespace :api do
    resources :answers, only: [:show]
  end

end