Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      # auth_token
      resources :auth_token, only:[:create] do
        post   :refresh, on: :collection
        delete :destroy, on: :collection
      end

      resources :users do
        delete :destroy, on: :collection
        put    :update,  on: :collection
      end
      
      # projects
      resources :projects do
        delete :destroy, on: :collection
        put    :update, on: :collection
      end
      # tasks
      resources :tasks do
        delete :destroy, on: :collection
        put    :update, on: :collection
      end
      # カンパニー一覧
      resources :companies do
        put    :update,  on: :collection
        delete :destroy, on: :collection
      end
      # カンパニー参加user
      resources :company_users do
        get    :owner,   on: :collection 
        delete :destroy, on: :collection
      end
      # 共有プロジェクト
      resources :company_projects do
        put    :update,  on: :collection
        delete :destroy, on: :collection
      end
      # 共有プロジェクトのtask
      resources :company_tasks do
        put    :update,  on: :collection
        delete :destroy, on: :collection
      end
      
      resources :account_activations, only:[:index] 

       # password_resets
       resources :password_resets do
        put     :update,  on: :collection
         delete :destroy, on: :collection
       end
      
      resources :finders do
        post   :refresh, on: :collection
      end

    end
  end
end
