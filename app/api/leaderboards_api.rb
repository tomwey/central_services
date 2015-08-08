module API
  
  class LeaderboardsAPI < Grape::API
    resource :leaderboards do
      # 1、获取某个游戏下面的所有排行榜
      params do
        requires :app_secret_key, type: String, desc: "App Secret Key"
      end
      get do
        @game = App.find_by(secret_key: params[:app_secret_key])
        if @game.blank?
          return { code: 2001, message: 'Not Found Game' }
        end
        
        @leaderboards = Leaderboard.where(game_id: @game.id)
        if params[:page]
          @leaderboards = @leaderboards.paginate page: params[:page], per_page: page_size
        end
        
        render_json(@leaderboards, API::Entities::Leaderboard)
      end # end get /leaderboards
      
      # 2、获取某个排行榜的信息
      get '/show/:lb_secret_key' do
                
        @leaderboard = Leaderboard.find_by(secret_key: params[:lb_secret_key])
        
        render_json(@leaderboard, API::Entities::Leaderboard)
      end # end /show/12
      
      # 3、为某个游戏创建一个排行榜
      params do
        requires :app_secret_key, type: String, desc: "App Key"
        requires :name, type: String, desc: "排行榜名称"
      end
      post do
        @game = App.find_by(secret_key: params[:app_secret_key])
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
      # 获取前50个排行榜数据
      params do
        requires :b, type: String, desc: "当前app对应的包名或者bundle id"
      end
      get :players do
        # @leaderboard = Leaderboard.find_by(secret_key: params[:lb_secret_key])
        # if @leaderboard.blank?
        #   return { code: 2002, message: "Not Found Leaderboard" }
        # end
        
        @app = App.find_by(app_id: params[:b])
        if @app.blank?
          return { code: -1, message: "App not register in server." }
        end
        
        @leaderboard = Leaderboard.where(game_id: @app.id).first
        if @leaderboard.blank?
          @leaderboard = Leaderboard.create(name: "#{@app.name}的排行榜", game_id: @app.id)
          if @leaderboard.blank?
            return { code: 2002, message: "Not Found Leaderboard for current app" }
          end
        end
        
        @scores = @leaderboard.scores.sort_by_value
        if params[:page]
          @scores = @scores.paginate page: params[:page], per_page: page_size
        else
          @scores = @scores.paginate page: 1, per_page: 50
        end
        
        # @score = @leaderboard.scores.where(user_id: @user.id).first
        
        { code: 0, message: 'ok', data: { total: Score.where(leaderboard_id: @leaderboard.id).count, scores: @scores } }
      end # end players
      
      # 获取与我相关的排行数据
      params do
        requires :token, type: String, desc: "Token"
        requires :b, type: String, desc: "当前app对应的包名或者bundle id"
        optional :s, type: Integer, desc: "显示排名总数，默认为5条"
      end
      get :me do
        player = Player.find_by(private_token: params[:token])
        
        if player.blank?
          return { code: -1, message: "玩家未登录或者认证不正确" }
        end
        
        @app = App.find_by(app_id: params[:b])
        if @app.blank?
          return { code: -1, message: "App not register in server." }
        end
        
        @leaderboard = Leaderboard.where(game_id: @app.id).first
        if @leaderboard.blank?
          @leaderboard = Leaderboard.create(name: "#{@app.name}的排行榜", game_id: @app.id)
          if @leaderboard.blank?
            return { code: 2002, message: "Not Found Leaderboard for current app" }
          end
        end
        
        my_score = @leaderboard.scores.where(player_id: player.id).first
        
        if my_score.blank?
          return { code: -1, message: "您还没有上传分数" }
        end
        
        if params[:s]
          count = params[:s].to_i
        else
          count = 2
        end
        
        count = 2 if count < 2
        
        score_ids = []
        
        first_three_score_ids = @leaderboard.scores.select('id').where('value >= ? and id != ?', my_score.value, my_score.id).order('value asc, id desc').limit(count).map(&:id)
        
        score_ids += first_three_score_ids
        
        score_ids << my_score.id
        
        last_three_score_ids = @leaderboard.scores.select('id').where('value < ?', my_score.value).order('value desc, id desc').limit(count).map(&:id)
        
        score_ids += last_three_score_ids
        
        @scores = @leaderboard.scores.includes(:player).where(id: score_ids).order('value desc, id desc')
        
        { code: 0, message: "ok", data: { total: Score.where(leaderboard_id: @leaderboard.id).count, scores: @scores || [] } }
        
      end #end me
      
      # 上传分数
      params do
        requires :score, type: Integer, desc: "当前分数"
        requires :token, type: String, desc: "Token"
        requires :b, type: String, desc: "当前app对应的包名或者bundle id"
      end
      post :upload_score do
        player = Player.find_by(private_token: params[:token])
        if player.blank?
          return { code: -1, message: "玩家未登录或者认证不正确" }
        end
        
        @app = App.find_by(app_id: params[:b])
        if @app.blank?
          return { code: -1, message: "App not register in server." }
        end
        
        @leaderboard = Leaderboard.where(game_id: @app.id).first
        if @leaderboard.blank?
          @leaderboard = Leaderboard.create(name: "#{@app.name}的排行榜", game_id: @app.id)
          if @leaderboard.blank?
            return { code: 2002, message: "Not Found Leaderboard for current app" }
          end
        end
        
        @score = @leaderboard.scores.where(player_id: player.id).first
        if @score.blank?
          @score = Score.new(value: params[:score].to_i, player_id: player.id, leaderboard_id: @leaderboard.id)
        else
          @score.value = params[:score].to_i if params[:score].to_i > @score.value
        end
        
        if @score.save
          { code: 0, message: "ok", data: @score }
        else
          { code: 2003, message: "上传分数失败!" }
        end
        
      end # end upload score
    end # end leaderboard resource
     
  end
  
end