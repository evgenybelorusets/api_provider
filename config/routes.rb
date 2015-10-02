Rails.application.routes.draw do
  devise_for :client_applications
  root 'client_applications#show'

  resources :client_applications, only: :show
end
