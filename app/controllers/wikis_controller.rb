class WikisController < ApplicationController
  
  def index
    @wikis = Wiki.order('id desc').paginate page: params[:page], per_page: 30
  end
  
  def show
    @wiki = Wiki.find(params[:id])
  end
  
  def new
    @wiki = Wiki.new
  end
  
  def create
    @wiki = Wiki.new(wiki_params)
    if @wiki.save
      flash[:notice] = '创建成功'
      redirect_to @wiki
    else
      render :new
    end
  end
  
  def edit
    @wiki = Wiki.find(params[:id])
  end
  
  def update
    @wiki = Wiki.find(params[:id])
    
    if @wiki.update(wiki_params)
      flash[:notice] = '修改成功'
      redirect_to @wiki
    else
      render :edit
    end
  end
  
  def destroy
    @wiki = Wiki.find(params[:id])

    @wiki.destroy
    
    redirect_to wikis_url
  end
  
  private
    def wiki_params
      params.require(:wiki).permit(:title, :body)
    end
end