class AppDataController < ApplicationController
  def index
    @app_data = AppData.order('id DESC').paginate page: params[:page], per_page: 30
  end
  
end