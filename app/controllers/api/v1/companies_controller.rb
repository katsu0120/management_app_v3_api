class Api::V1::CompaniesController < ApplicationController

  include UserSessionizeService
 before_action :authenticate_active_user

  # userが参加しているCompany一覧
  def index 
     @company_user = current_user.following
     render json: @company_user
  end

  



end
