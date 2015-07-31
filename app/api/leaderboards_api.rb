module API
  
  class LeaderboardsAPI < Grape::API
    resource :leaderboards do
      # 获取某个游戏下面的所有排行榜
      params do
        requires :app_key, type: String, desc: "App Key"
      end
      get do
        @game = App.find_by(app_key: params[:app_key])
        if @game.blank?
          return { code: 2001, message: 'Not Found Game' }
        end
        
        @leaderboards = Leaderboard.where(game_id: @game.id)
        if params[:page]
          @leaderboards = @leaderboards.paginate page: params[:page], per_page: page_size
        end
        
        render_json(@leaderboards, API::Entities::Leaderboard)
      end # end get /leaderboards
      
      # 获取某个排行榜的信息
      params do
        requires :app_key, type: String, desc: "App Key"
      end
      get '/show/:leaderboard_id' do
        
        @game = App.find_by(app_key: params[:app_key])
        if @game.blank?
          return { code: 2001, message: 'Not Found Game' }
        end
        
        @leaderboard = Leaderboard.find_by(id: params[:leaderboard_id], game_id: @game.id)
        
        render_json(@leaderboard, API::Entities::Leaderboard)
      end # end /show/12
      
      # 为某个游戏创建一个排行榜
      params do
        requires :app_key, type: String, desc: "App Key"
        requires :name, type: String, desc: "排行榜名称"
      end
      post do
        @game = App.find_by(app_key: params[:app_key])
        if @game.blank?
          return { code: 2001, message: 'Not Found Game' }
        end
        
        @leaderboard = Leaderboard.find_by(game_id: @game.id, name: params[:name])
        if @leaderboard.blank?
          # return render_json(@leaderboard, API::Entities::Leaderboard)
          @leaderboard = Leaderboard.create!(game_id: @game.id, name: params[:name])
        end
        
        render_json(@leaderboard, API::Entities::Leaderboard)
      end # end create leaderboard
      
    end # end leaderboards resource
    
    resource :leaderboard do
      # 获取排行榜数据
      params do
        requires :token, type: String, desc: "Token"
        requires :lb_id, type: Integer, desc: "排行榜id"
        requires :app_key, type: String, desc: "App Key"
      end
      get :players do
        user = authenticate!
        
        @game = App.find_by(app_key: params[:app_key])
        if @game.blank?
          return { code: 2001, message: 'Not Found Game' }
        end
        
        @leaderboard = Leaderboard.find_by(game_id: @game.id, id: params[:lb_id])
        if @leaderboard.blank?
          return { code: 2002, message: "Not Found Leaderboard" }
        end
        
        @scores = @leaderboard.scores.sort_by_value
        if params[:page]
          @scores = @scores.paginate page: params[:page], per_page: page_size
        else
          @scores = @scores.paginate page: 1, per_page: 50
        end
        
        @score = @leaderboard.scores.where(user_id: @user.id).first
        
        { code: 0, message: 'ok', data: { total: Score.where(leaderboard_id: @leaderboard.id).count, game: @game, scores: @scores, me: @score || {} } }
        
      end # end get players
      
      # 上传分数
      params do
        requires :score, type: Integer, desc: "当前分数"
        requires :token, type: String, desc: "Token"
        requires :lb_id, type: Integer, desc: "排行榜id"
        requires :app_key, type: String, desc: "App Key"
      end
      post :upload_score do
        user = authenticate!
        
        @game = App.find_by(app_key: params[:app_key])
        if @game.blank?
          return { code: 2001, message: 'Not Found Game' }
        end
        
        @leaderboard = Leaderboard.find_by(game_id: @game.id, id: params[:lb_id])
        if @leaderboard.blank?
          return { code: 2002, message: "Not Found Leaderboard" }
        end
        
        @score = @leaderboard.scores.where(user_id: user.id).first
        if @score.blank?
          @score = Score.new(value: params[:score].to_i, user_id: user.id, leaderboard_id: @leaderboard.id)
        else
          @score.value = params[:score].to_i if params[:score].to_i > @score.value
        end
        
        if @score.save
          { code: 0, message: "ok", data: @score }
        else
          { code: 2003, message: "上传粉丝失败!" }
        end
        
      end # end upload score
    end # end leaderboard resource
     
  end
  
end