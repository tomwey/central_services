class AdTracksController < ApplicationController
  def index
    @tracks = AdTrack.order('id DESC').paginate page: params[:page], per_page: 30
  end
  
end