Rails.application.routes.draw do
  
  require 'api_v1'
  
  devise_for :users

  mount API::APIV1 => '/'
end
