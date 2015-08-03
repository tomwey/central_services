module API
  class PlayersAPI < Grape::API 
    resource :auth do
      params do
        optional :nickname, type: String, desc: "昵称"
        optional :avatar, desc: "二进制图片数据"
        requires :uid, type: String, desc: "三方认证uid"
        requires :provider, type: String, desc: "三方认证名字，例如：Sina, Wechat"
      end
      post :bind do
        player = Player.find_by(uid: params[:uid], provider: params[:provider])
        if player.present?
          return { code: 0, message: "ok", data: player }
        end
        
        player = Player.new(uid: params[:uid], provider: params[:provider])
        if params[:avatar]
          player.avatar = params[:avatar]
        end
        
        player.nickname = params[:nickname] || Array.new(6){[*'0'..'9'].sample}.join
        
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