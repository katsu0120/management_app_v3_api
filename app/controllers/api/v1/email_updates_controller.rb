class Api::V1::EmailUpdatesController < ApplicationController

  before_action :authenticate_active_user, only: [:create]
  before_action :authenticate_email_changed_active_user, only: [:update]

  def create
    lifetime = 10.minute
    new_email = email_params[:new_email].downcase
    token = current_user.to_access_token(lifetime: lifetime, new_email: new_email)
    current_user.send_email_update_email(new_email, token)
    render json: token
  end


  def update
    user = current_user
    new_email = decode_access_token.payload["new_email"]
    color = "error"
    msg = "無効なURLです"
    # new_emailが存在して尚且つDBに無かったら、登録されているアドレスではないし
    # 一意なので通過させる
    if new_email.present? && User.find_by_activated(new_email).nil?
      if user.update!(email: new_email)
        color = "success"
        msg = "メールアドレスを変更しました"
      else
        msg = "メールアドレスの変更に失敗しました"
      end
    end
    render json: { color: color, msg: msg }
  end





  private

  def new_email_params
    params.require(:user).permit(:email )
  end

  def old_email_params
    params.require(:user).permit(:id, :old_email, )
  end

  def email_params
    params.require(:user).permit(:old_email, :new_email)
  end

end
