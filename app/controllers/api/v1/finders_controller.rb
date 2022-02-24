class Api::V1::FindersController < ApplicationController
  def index
    findUser = params[:findName]
    @users = User.where("name LIKE ?", "%#{findUser}%")
    render json: @users
  end
end
