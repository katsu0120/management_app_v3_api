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
        put    :update,  on: :collection
      end
      
      # projects
      resources :projects do
        post   :refresh, on: :collection
        delete :destroy, on: :collection
        put    :update, on: :collection
      end
      # tasks
      resources :tasks do
        post   :refresh, on: :collection
        delete :destroy, on: :collection
        put    :update, on: :collection
      end

      resources :account_activations do
        post   :refresh, on: :collection
      end

    end
  end
end
