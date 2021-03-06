class HomeController < ApplicationController
  # skip_before_action :basic, only: [:video, :longphung, :get_customer]

  def index
    @articles = Article.all
    @high_lights = Match.where(high_light: true).order(created_at: :DESC).limit(10)
  end

  def show
    @match = Match.find_by(id: params[:match_id])
    if @match.matchable.is_a?(Article)
      @article = @match.matchable
    else
      @article = @match.matchable.article
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
    if request.env['HTTP_USER_AGENT'] =~ /[^\(]*[^\)]Chrome\//
      response.headers["Accept-Ranges"]=  "bytes"
      response.headers["Content-Length"] = "#{size}"

      send_file(file_path, :type => "video/mp4", :disposition => 'inline', :stream => true, :file_name => "hula.mp4")
    else
      if request.headers["HTTP_RANGE"].present?
        bytes = Rack::Utils.byte_ranges(request.headers, size)[0]
        offset = bytes.begin
        length = bytes.end - bytes.begin + 1
        response.headers["Accept-Ranges"]=  "bytes"
        response.headers["Content-Range"] = "bytes #{bytes.begin}-#{bytes.end}/#{size}"
        response.headers["Content-Length"] = "#{length}"

        send_data IO.binread(file_path,length, offset), :type => "video/mp4", :stream => true,  :disposition => 'inline', :file_name => "hula.mp4"

      else
        response.headers["Accept-Ranges"]=  "bytes"
        response.headers["Content-Length"] = "#{size}"

        send_file(file_path, :type => "video/mp4", :disposition => 'inline', :stream => true, :file_name => "hula.mp4")
      end
    end
  end
end
