class Api::V1::CompanyProjectsController < ApplicationController

  def index 
    @company_projects = current_user.following.find_by(id: params[:id])&.projects
    render json: @company_projects
  end
end
