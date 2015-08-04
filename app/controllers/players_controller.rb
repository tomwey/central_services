class PlayersController < ApplicationController
  def index
    @players = Player.order('id DESC').paginate page: params[:page], per_page: 30
  end
  
end