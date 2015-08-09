class AdsController < ApplicationController
  
  def index
    @ads = Ad.order('id desc').paginate page: params[:page], per_page: 30
  end
  
  def new
    @ad = Ad.new
  end
  
  def create
    @ad = Ad.new(ad_params)
    if @ad.save
      flash[:notice] = '创建成功'
      redirect_to ads_path
    else
      render :new
    end
  end
  
  def edit
    @ad = Ad.find(params[:id])
  end
  
  def update
    @ad = Ad.find(params[:id])
    
    if @ad.update(ad_params)
      flash[:notice] = '修改成功'
      redirect_to ads_path
    else
      render :edit
    end
  end
  
  def destroy
    @ad = Ad.find(params[:id])

    @ad.destroy
    
    redirect_to ads_url
  end
  
  private
    def ad_params
      params.require(:ad).permit(:ad_type, :title, :message, :link, :button_titles, :lang, app_ids: [])
    end
end