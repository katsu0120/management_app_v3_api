class Api::V1::CompaniesController < ApplicationController

  include UserSessionizeService
 before_action :authenticate_active_user

  # userが参加しているCompany一覧
  def index 
     companies = current_user.following
     render json: companies
  end

  def create
    companies = current_user.companies.create!(company_name_params)
    # カンパニー作成と共に自動的にオーナーを参加させている
    companies.users.create!(user_id:current_user.id)
    render json: companies
  end

  def update
    company = current_user.companies.find_by(company_id_params)
    company.update!(company_name_params)
    render json: company
  end

  def destroy
    company = current_user.companies.find_by(company_id_params)
    company.destroy
    render json: company
  end
  

  private

  def company_name_params
    params.require(:company).permit(:id, :name)
  end

  def company_id_params
    params.require(:company).permit(:id)
  end



end
