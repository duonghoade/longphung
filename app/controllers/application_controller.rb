class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :basic

  def basic
    authenticate_or_request_with_http_basic do |user, pass|
      user == "techfactory" && pass == "otokake0604"
    end
  end

end
