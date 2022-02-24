class Api::V1::CompanyUsersController < ApplicationController

  def index
    company_users = Company.find_by(id: params[:id]).users_details
    render json: company_users
  end

  def create
    company_user = Company.find_by(company_params).users.create!(users_params)
    render json: company_user
  end

  def destroy
    company_user = Company.find_by(company_params).users.find_by(users_params)
    company_user.destroy
    render json: company_user
  end
    

  # Company作成者を返す
  def owner
    owner_user = Company.find_by(id: params[:id]).owner
    render json: owner_user
  end


  private
  
  def users_params
    params.require(:users).permit(:user_id)
  end

  def company_params
    params.require(:company).permit(:id)
  end



end
