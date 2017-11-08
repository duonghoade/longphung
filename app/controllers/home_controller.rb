class HomeController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @macth = Macth.find_by(id: params[:macth_id])
    if @macth.macthable.is_a?(Article)
      @article = @macth.macthable
    else
      @article = @macth.macthable.article
    end
    if params[:url_slug] != @article.url_slug
      raise fuck
    end
    @games = @article.games.order(c_num: :ASC)
  end

  def longphung
    render layout: false
  end
end
