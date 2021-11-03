Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      # auth_token
      resources :auth_token, only:[:create] do
        post   :refresh, on: :collection
        delete :destroy, on: :collection
      end
      resources :users do
        post   :refresh, on: :collection
        delete :destroy, on: :collection
      end
      
      resources :hello, only: [:index]
      resources :posts, only: [:index, :create]

      # projects
      resources :projects, only:[:index]

    end
  end
end
