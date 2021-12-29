class Api::V1::TasksController < ApplicationController
 
  def index
    @tasks = current_user.projects.find_by(id: params[:id])&.tasks || []
    render json: @tasks
  end

  def create
    @task = current_user.projects.find_by(project_params)&.tasks.create!(task_params)
    render json: @task
    # @user = current_user
    # render json: @user
  end

  def update
    @task = current_user.projects.find_by(project_params)&.tasks.find_by(id_params)
    @task.update!(task_params)
    render json: @task
  end
  
  def destroy
    @task = current_user.projects.find_by(project_params).tasks.find_by(id_params)
    @task.destroy
    render json: @task
  end



  private

  def id_params
    params.require(:task).permit(:id)
   end

  def task_params
    params.require(:task).permit(:id, :title, :content, :completed)
  end

  def project_params
    params.require(:project).permit(:id)
  end

end
