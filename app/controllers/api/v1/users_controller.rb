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
    @user.activation_token = @user.to_access_token
    @user.send_activation_email   
    render json: @user
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
