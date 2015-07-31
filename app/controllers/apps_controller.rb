class AppsController < ApplicationController
  
  def index
    @apps = App.order('id desc').paginate page: params[:page], per_page: 30
  end
  
  def new
    @app = App.new
  end
  
  def create
    @app = App.new(app_params)
    if @app.save
      flash[:notice] = '创建成功'
      redirect_to apps_path
    else
      render :new
    end
  end
  
  def edit
    @app = App.find(params[:id])
  end
  
  def update
    @app = App.find(params[:id])
    
    if @app.update(app_params)
      flash[:notice] = '修改成功'
      redirect_to apps_path
    else
      render :edit
    end
  end
  
  def destroy
    @app = App.find(params[:id])

    Leaderboard.where(game_id: @app.id).delete_all
    
    @app.destroy
    
    redirect_to apps_url
  end
  
  private
    def app_params
      params.require(:app).permit(:name, :icon, :icon_cache, :store_url, :app_type, :platform, :version, :app_id)
    end
end