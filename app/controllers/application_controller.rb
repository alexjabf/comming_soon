class ApplicationController < ActionController::Base
  include ApplicationHelper
  include DevelopmentToolsHelper
  include GlobalHelper   
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :get_user_status, :set_locale, :get_style, :get_models_for_sidebar, :set_faye_url
  before_filter :get_searchable_columns, :get_indexable_columns, :has_sorting_params, :only => [:index]
  
  def set_faye_url
    session[:faye_url] = Rails.env.development? ? "http://#{IPSocket.getaddress(Socket.gethostname)}:9292/faye" : "http://www.railstogo.com:9292/faye"
  end
  
  def get_models_for_sidebar
    @models = Dir['app/models/*.rb'].map { |f| File.basename(f, '.*').camelize.constantize.name }
    @models -= %w{Ability}
    modeles_for_permissions = []
    side_models = []
    @models.each do |model|
      if can? :index, to_model(model) and has_index?(model)
        modeles_for_permissions << {'name' => model, 'human_name' => t("activerecord.models.#{to_controller_name(model)}")}
        unless model == "CustomScaffold" or model == "ColumnAttribute" or model == "SchemaMigration"
          side_models << {'name' => model, 'human_name' => t("activerecord.models.#{to_controller_name(model)}")}
        end
      end
    end
    @sidebar = side_models.sort_by { |m| m["human_name"] }
  end
  
  def has_sorting_params
    if params[:order_by] or params[:per_page] or params[:sort_by]
      @has_params = true
    end
  end
  
  def get_style
    @margin = action_name == "index" ? "margin-top" : "margin-bottom"
    @padding = (has_index?(controller_name) and eval("#{to_model(controller_name)}.count") > 0) ? "-42" : "6"
  end
  
  def set_locale
    unless params[:locale].blank?
      session[:locale] = params[:locale]
    end
    I18n.locale = session[:locale] || I18n.default_locale
  end
  
  def get_searchable_columns
    get_searchable_columns_names if is_model?(controller_name)
  end
  
  def get_indexable_columns
    get_indexable_columns_names if is_model?(controller_name)
  end
  
  def get_user_status
    if signed_in?
      @app = App.find(4)
      unless current_user.active or !@app.nil?
        sign_out(current_user)
        redirect_to root_path, :alert => t("errors.messages.account_inactive")
      end
    end
  end
end
