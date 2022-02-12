class Api::V1::FindersController < ApplicationController
  def index
    # @user = User.where("name LIKE ?", "%#{words}%")
    # @name = params.require(:user).permit(:name)
    findUser = params[:findName]
    # @users = User.looks(params[:findName)
    @users = User.where("name LIKE ?", "%#{findUser}%")
    render json: @users
  end
end
