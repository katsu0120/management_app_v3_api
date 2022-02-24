class Api::V1::CompanyTasksController < ApplicationController


  def index 
    company_tasks = current_user.following.find_by(id: params[:id])&.projects.find_by(id: params[:projectId]).tasks
    render json: company_tasks
  end

  def create
    company_tasks = current_user.following.find_by(company_params)&.projects.find_by(project_id_params).tasks.create!(task_params)
    render json: company_tasks
  end

  def update
    company_tasks = current_user.following.find_by(company_params)&.projects.find_by(project_id_params).tasks.find_by(task_id_params)
    company_tasks.update(task_params)
    render json: company_tasks
  end

  def destroy
    company_tasks = current_user.following.find_by(company_params)&.projects.find_by(project_id_params).tasks.find_by(task_id_params)
    company_tasks.destroy
    render json: company_tasks
  end

  private


  def company_params
    params.require(:company).permit(:id)
  end

  def project_id_params
    params.require(:project).permit(:id)
  end

  def project_edit_params
    params.require(:project).permit(:title, :content, :updated_at, :completed)
  end

  def task_params
    params.require(:task).permit(:title, :content, :completed)
  end

  def task_id_params
    params.require(:task).permit(:id)
  end


end
