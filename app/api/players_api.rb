module API
  class PlayersAPI < Grape::API 
    resource :auth do
      params do
        optional :nickname, type: String, desc: "昵称"
        optional :avatar, type: String, desc: "二进制图片数据"
        requires :uid, type: String, desc: "三方认证uid"
        requires :provider, type: String, desc: "三方认证名字，例如：Sina, Wechat"
        requires :u,  type: String, desc: "UDID"
        requires :m,  type: String, desc: "设备型号名称"
        requires :ov, type: String, desc: "操作系统版本"
        requires :lc, type: String, desc: "语言code，例如：en / zh"
        requires :cc, type: String, desc: "国家码，例如：CN / US"
        requires :sr, type: String, desc: "设备屏幕分辨率"
        requires :p,  type: String, desc: "设备平台, iOS / Android"
      end
      post :bind do
        player = Player.find_by(uid: params[:uid], provider: params[:provider])
        if player.blank?
          player = Player.new(uid: params[:uid], provider: params[:provider])
          player.nickname = params[:nickname] || Array.new(6){[*'0'..'9'].sample}.join
        else
          if params[:nickname]
            player.nickname = params[:nickname]
          end
        end
        
        if params[:avatar]
          player.avatar = params[:avatar]
        end
        
        player.udid  = params[:u]
        player.model = params[:m]
        player.os_version = params[:ov]
        player.language_code = params[:lc]
        player.country_code = params[:cc]
        player.screen_size = params[:sr]
        player.platform = params[:p]
        
        if player.save
          player.ensure_private_token!
          { code: 0, message: "ok", data: player }
        else
          { code: -2, message: "绑定失败!" }
        end
      end
      
    end # end auth resource
  end
end