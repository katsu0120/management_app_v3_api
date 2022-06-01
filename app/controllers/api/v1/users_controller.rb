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
    color = "error"
    msg = "すでに使われているユーザーネームです😅"
    # 使われていないユーザーネームの場合trueになる
    if User.find_by(name: user_params[:name]).nil?
      if @user = User.find_by_activated(user_params[:email])
          msg = "すでに会員登録されております😭"
          color = "#D50000"
        else
          @user = User.new(user_params)
          @user.save
          @user.activation_token = @user.encode_access_token(payload = {lifetime:1.hours})
          @user.send_activation_email   
          msg = "ご登録のメールアドレスに認証メールをご送付させていただきました"
          color = "#0091EA" 
        end
    end
    render json: { color: color, msg: msg }
  end


  def update
    @user = User.find_by(id_params)
    if @user.update(edit_params)
      msg = "ユーザー名の変更が完了しました😄"
      color =  "#388E3C" 
    else
      msg = "すでに使われているユーザー名です。登録出来ませんでした😭"
      color = "#D50000" 
    end
    render json: { color: color, msg: msg }
  end

  def update_profile
    @user = current_user
    if @user.update(edit_params)
      msg = "プロフィールの変更が完了しました😄"
      color = "#388E3C"
    else
      msg = "プロフィールの変更に失敗しました"
      color = "error"
    end
    render json: { color: color, msg: msg}
  end

  private

  def user_params
    params.require(:user).permit(:id, :name, :email, :password,)
  end

  def id_params
    params.require(:user).permit(:id)
  end

  def edit_params
  params.require(:user).permit(:name, :email, :password, :user_profile)
  end

end


