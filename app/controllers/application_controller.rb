class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_faye_url
  
  def set_faye_url
    session[:faye_url] = Rails.env.development? ? "http://#{IPSocket.getaddress(Socket.gethostname)}:9292/faye" : "http://www.railstogo.com:9292/faye"
  end
  
  def set_locale
    unless params[:locale].blank?
      session[:locale] = params[:locale]
    end
    I18n.locale = session[:locale] || I18n.default_locale
  end
  
  rescue_from Exception do |exception|
    render root_path
  end
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render root_path
  end 
  rescue_from ActionController::RoutingError do |exception|
    render root_path
  end

end
