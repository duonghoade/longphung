class HomeController < ApplicationController
  skip_before_action :basic, only: [:video]

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

  def get_customer
    code = GiftCode.find_by(code: params[:code])
    customer = code.customer
    render json: {
      name: customer.name,
      phone: customer.phone
    }
  end

  def video
    file_path = Rails.root.join("public/hula.mp4")
    size = File.size(file_path)
    response.headers["Accept-Ranges"] = "bytes"
    response.headers["Content-Range"] = "bytes #{size}/#{size}"
    response.headers["Content-Length"] = size
    send_file file_path, type: 'video/mp4', disposition: :inline, stream: true
  end
end
