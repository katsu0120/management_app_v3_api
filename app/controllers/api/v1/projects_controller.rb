class Api::V1::ProjectsController < ApplicationController

  def index
    render json: current_user.projects
  end
  
  def create
    @project = current_user.projects.create!(project_params)
    render json:  @project
  end

  def update
    @project = current_user.projects.find_by(id_params)
    @project.update(project_params)
    render json: @project
  end

  def destroy
    @project = current_user.projects.find_by(id_params)
    @project.destroy
    render json: @project
  end


  private

  def id_params
    params.require(:project).permit(:id)
  end

  def project_params
    params.require(:project).permit(:title, :content, :updated_at, :completed)
  end

end
