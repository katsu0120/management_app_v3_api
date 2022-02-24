class Api::V1::CompanyProjectsController < ApplicationController

  def index 
    company_projects = current_user.following.find_by(id: params[:id])&.projects
    render json: company_projects
  end

  def create
    company_projects = current_user.following.find_by(company_params).projects.create!(project_params)
    render json: company_projects
  end

  def update
    company_projects =  current_user.following.find_by(company_params).projects.find_by(project_id_params)
    company_projects.update(project_params)
    render json: company_projects
  end



  private

  def company_params
    params.require(:company).permit(:id)
  end

  def project_params
    params.require(:project).permit(:user_id, :title, :content, :updated_at, :completed)
  end

  def project_id_params
    params.require(:project).permit(:id)
  end

  def project_edit_params
    params.require(:project).permit(:title, :content, :updated_at, :completed)
  end



end
