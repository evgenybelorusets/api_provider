Rails.application.routes.draw do
  devise_for :client_applications
  root 'client_applications#show'

  resources :client_applications, only: :show

  namespace :api do
    namespace :v1, path: 'v1/:user_uid' do
      resources :users, except: [ :new, :edit ]
      resources :posts, except: [ :new, :edit ] do
        resources :comments, except: [ :new, :edit ]
      end
    end
  end
end
