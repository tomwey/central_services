class LeaderboardsController < ApplicationController
  
  def index
    @leaderboards = Leaderboard.order('id desc').paginate page: params[:page], per_page: 30
  end
  
  def new
    @leaderboard = Leaderboard.new
  end
  
  def show
    @leaderboard = Leaderboard.find(params[:id])
    @scores = @leaderboard.scores.sort_by_value.paginate page: params[:page], per_page: 30
  end
  
  def create
    @leaderboard = Leaderboard.new(leaderboard_params)
    if @leaderboard.save
      flash[:notice] = '创建成功'
      redirect_to leaderboards_path
    else
      render :new
    end
  end
  
  def edit
    @leaderboard = Leaderboard.find(params[:id])
  end
  
  def update
    @leaderboard = Leaderboard.find(params[:id])
    
    if @leaderboard.update(leaderboard_params)
      flash[:notice] = '修改成功'
      redirect_to leaderboards_path
    else
      render :edit
    end
  end
  
  def destroy
    @leaderboard = Leaderboard.find(params[:id])

    @leaderboard.destroy
    
    redirect_to leaderboards_url
  end
  
  private
    def leaderboard_params
      params.require(:leaderboard).permit(:name, :game_id)
    end
end