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
    if @user = User.find_by_activated(user_params[:email])
      error = { msg: "すでに会員登録されております", color: "#D50000" }
      render json: error
    else
      @user = User.new(user_params)
      @user.save
      @user.activation_token = @user.encode_access_token(payload = {lifetime:1.hours})
      @user.send_activation_email   
      success = { msg: "ご登録のメールアドレスに認証メールをご送付させていただきました", color: "#0091EA" }
      render json: success
    end
  end

  def update
    @user = User.find_by(id_params)
    @user.update(edit_params)
    render json: @user
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
