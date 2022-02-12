class Api::V1::PasswordResetsController < ApplicationController

  include UserSessionizeService

  before_action :authenticate_active_user, only: [:index, :update]

  def index
    @user = current_user
    set_refresh_token_to_cookie
    render json: login_response
  end

  def create
    @user = User.find_by_activated(password_reset_params[:email])
    if @user
      @user.reset_token = @user.encode_access_token(payload = {lifetime:1.hours})
      @user.send_password_reset_email
      render json: @user
    else
      msg = { content: "メールを送付しました", url: "pikawaka" }
      render json: msg
    end
  end

  def update
    user = current_user
    user.update(password_edit_params)
    render json: user
  end

   private

  def password_reset_params
    params.require(:user).permit(:email)
  end

  def password_edit_params
    params.require(:user).permit(:password)
  end
  

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



