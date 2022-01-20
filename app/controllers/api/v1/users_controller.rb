class Api::V1::UsersController < ApplicationController

  include UserSessionizeService

  def index 
     @user = { id: current_user.id, name: current_user.name, email: current_user.email, user_profile: current_user.user_profile }
    
     render json: @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save
    @user.send_activation_email
    # @user.update(activated: true)
    # set_refresh_token_to_cookie
    render json: @user
    # render json: login_response
  end

  def update
    @user = User.find_by(id_params)
    # @user.update(edit_params)
    @user.update(edit_params)
    # @user.user_profile.update
    # @user = @user.user_profile
    render json: @user
  end

  private

   # refresh_tokenをcookieにセットする
   def set_refresh_token_to_cookie
     cookies[session_key] = {
       value: refresh_token,
       expires: refresh_token_expiration,
       secure: Rails.env.production?,
       http_only: true
     }
   end

   # ログイン時のデフォルトレスポンス
   def login_response
     {
       token: access_token,
       expires: access_token_expiration,
       user: @user.response_json(sub: access_token_subject)
     }
   end

   # リフレッシュトークンのインスタンス生成
   def encode_refresh_token
     @_encode_refresh_token ||= @user.encode_refresh_token
   end

   # リフレッシュトークン
   def refresh_token
     encode_refresh_token.token
   end

   # リフレッシュトークンの有効期限
   def refresh_token_expiration
     Time.at(encode_refresh_token.payload[:exp])
   end

   # アクセストークンのインスタンス生成
   def encode_access_token
     @_encode_access_token ||= @user.encode_access_token
   end

   # アクセストークン
   def access_token
     encode_access_token.token
   end

   # アクセストークンの有効期限
   def access_token_expiration
     encode_access_token.payload[:exp]
   end

   # アクセストークンのsubjectクレーム
   def access_token_subject
     encode_access_token.payload[:sub]
   end

   def user_params
     params.require(:user).permit(:name, :email, :password,)
   end

   def id_params
     params.require(:user).permit(:id)
   end

   def edit_params
    params.require(:user).permit(:name, :email, :password, :user_profile)
  end


 

end
