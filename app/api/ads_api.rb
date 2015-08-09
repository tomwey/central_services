module API
  class AdsAPI < Grape::API    
    resource :ads do
      params do
        requires :b,  type: String, desc: "app的bundle id或包名"
        requires :u,  type: String, desc: "UDID"
        requires :bv, type: String, desc: "当前app版本号"
        requires :m,  type: String, desc: "设备型号名称"
        requires :ov, type: String, desc: "操作系统版本"
        requires :w,  type: String, desc: "广告显示的模式，可以为：resume / launch"
        requires :lc, type: String, desc: "语言code，例如：en / zh"
        requires :cc, type: String, desc: "国家码，例如：CN / US"
        requires :sr, type: String, desc: "设备屏幕分辨率"
        requires :p,  type: String, desc: "设备平台, iOS / Android"
        optional :mr, type: String, desc: "app下载来自的区域"
      end
      get do
        @app = App.find_by(app_id: params[:b])
        if @app.blank?
          return { code: -1, message: "App not register in server." }
        end
        
        # 数据统计
        @data = AppData.find_by(app_id: @app.id, udid: params[:u], app_version: params[:bv])
        if @data.blank?
          AppData.create(udid: params[:u], 
                         app_version: params[:bv], 
                         device_model: params[:m],
                         os_version: params[:ov], 
                         language_code: params[:lc], 
                         country_code: params[:cc], 
                         from_market: params[:mr], 
                         screen_size: params[:sr], 
                         app_id: @app.id,
                         platform: params[:p] )
        end
        
        # 加载广告
        @ads = @app.ads.where(lang: params[:lc]).order('id DESC')
        
        render_json(@ads, API::Entities::AdDetail)
        
      end # end send
      
    end # end feedbacks resource
    
  end
end