Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      # auth_token
      resources :auth_token, only:[:create] do
        post   :refresh, on: :collection
        delete :destroy, on: :collection
      end

      resources :users, only:[:index, :new, :create] do
        delete :destroy, on: :collection
        put    :update,  on: :collection
        put    :update_profile, on: :collection
      end
      
      # 個人projects
      resources :projects, only:[:index, :create] do
        put    :update, on: :collection
        delete :destroy, on: :collection
      end
      # tasks
      resources :tasks, only:[:index, :create] do
        put    :update, on: :collection
        delete :destroy, on: :collection
      end
      # カンパニー一覧
      resources :companies, only:[:index, :create]  do
        put    :update,  on: :collection
        delete :destroy, on: :collection
      end
      # カンパニー参加user
      resources :company_users, only:[:index, :create] do
        get    :owner,   on: :collection 
        delete :destroy, on: :collection
      end
      # 共有プロジェクト
      resources :company_projects, only:[:index, :create] do
        put    :update,  on: :collection
        delete :destroy, on: :collection
      end
      # 共有プロジェクトのtask
      resources :company_tasks, only:[:index, :create]  do
        put    :update,  on: :collection
        delete :destroy, on: :collection
      end
      
      # account有効化
      resources :account_activations, only:[:index] 

      #  パスワードを忘れた
       resources :password_resets, only:[:index, :create] do
         put     :update,  on: :collection
       end

       # パスワードの変更
       resources :password_updates, only:[:index, :create] do
         post    :password_authentication,  on: :collection
         put     :update,  on: :collection
       end

       # email変更
       resources :email_updates, only:[:create] do
         put     :update,  on: :collection
       end
      
      resources :finders, only:[:index] 
    end
  end
end
