class SiteConfigsController < ApplicationController
  
  def index
    @site_configs = SiteConfig.order('id desc')#.paginate page: params[:page], per_page: 30
  end
  
  # def show
  #   @site_config = SiteConfig.find(params[:id])
  # end
  
  def new
    @site_config = SiteConfig.new
  end
  
  def create
    @site_config = SiteConfig.new(site_config_params)
    if @site_config.save
      flash[:notice] = '创建成功'
      redirect_to site_configs_path
    else
      render :new
    end
  end
  
  def edit
    @site_config = SiteConfig.find(params[:id])
  end
  
  def update
    @site_config = SiteConfig.find(params[:id])
    
    if @site_config.update(site_config_params)
      flash[:notice] = '修改成功'
      redirect_to site_configs_path
    else
      render :edit
    end
  end
  
  def destroy
    @site_config = SiteConfig.find(params[:id])

    @site_config.destroy
    
    redirect_to site_configs_url
  end
  
  private
    def site_config_params
      params.require(:site_config).permit(:key, :value)
    end
end