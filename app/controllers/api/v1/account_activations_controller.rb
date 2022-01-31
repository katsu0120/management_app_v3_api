class Api::V1::AccountActivationsController < ApplicationController

 include UserSessionizeService

 before_action :authenticate_user

 def index
  @user = current_user
  @user.update(activated: true)
  set_refresh_token_to_cookie
  render json: login_response
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

end