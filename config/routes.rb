Rails.application.routes.draw do
  
  require 'api_v1'
  
  root 'home#index'
  
  devise_for :users, skip: [:registrations], path: "auth", 
      path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret' },
      controllers: { sessions: "users/sessions" }
  
  as :user do
    get 'account/password/edit' => 'devise/registrations#edit', as: :edit_user_registration
    patch 'account/password/update'  => 'devise/registrations#update', as: :user_registration
  end
  
  resources :leaderboards
  resources :apps
  resources :ads
  # resources :users
  resources :players, only: [:index]
  resources :feedbacks, only: [:index]
  resources :app_data, path: "analytics"

  mount API::APIV1 => '/'
end
