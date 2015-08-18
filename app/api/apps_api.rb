module API
  class AppsAPI < Grape::API 
    resource :apps do
      # 1、获取所有的app
      params do
        optional :p, type: Integer, desc: "app平台，1为iOS, 2为Android"
        optional :at, type: Integer, desc: "app类型，1为应用，2为游戏"
      end
      get do
        @apps = App.order('id desc')
        
        if params[:p]
          platform = params[:p].to_i == 1 ? "iOS" : "Android"
          @apps = @apps.where(platform: platform)
        end
        
        if params[:at]
          app_type = params[:at].to_i == 2 ? "游戏" : "应用"
          @apps = @apps.where(app_type: app_type)
        end
        
        if params[:page]
          @apps = @apps.paginate page: params[:page], per_page: page_size
        end
        
        { code: 0, message: "ok", data: @apps }
      end # end get /
      
    end # end apps resource
    
    resource :app_info do
      params do
        requires :b, type: String, desc: "App Bundle id / Package name"
      end
      get do
        @app = App.find_by(app_id: params[:b])
        { code: 0, message: "ok", data: @app || {} }
      end # end get /app_info
      
    end # end app_info resource
    
  end
end