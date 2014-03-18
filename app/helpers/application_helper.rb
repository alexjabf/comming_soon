module ApplicationHelper
  
  def flash_msg
    flash_collection = []
    if flash[:notice]
      flash_collection << content_tag(:div, flash[:notice], :class => "notice")
    end
    if flash[:alert]
      flash_collection << content_tag(:div, flash[:alert], :class => "alert")
    end
    if flash[:error]
      flash_collection << content_tag(:div, flash[:error], :class => "error")
    end
    if flash[:warning]
      flash_collection << content_tag(:div, flash[:warning], :class => "warning")
    end
    if flash[:success]
      flash_collection << content_tag(:div, flash[:notice], :class => "success")
    end
    return flash_collection.join.html_safe
  end
  
  def data 
    if signed_in?
      eval("@#{get_controller_name} = to_model(get_controller_name).order('id DESC').paginate(:per_page => params[:per_page], :page => params[:page])")
      eval("@#{get_controller_name}_select = to_model(get_controller_name).order('id DESC')")
      belongs_to_models(get_controller_name).each do |model|
        unless model['name'].nil?
          eval("@#{to_controller_name(model['name'])}_select = to_model(model['name']).order('id DESC')")
        end
      end
    else
      @role = Role.find_by_guess(true)
    end
    if action_name == "index"
      unless params[:controller_name].blank?
        advanced_search
      end
      unless params[:current_controller].blank?
        quick_search
      end
    end
  end
  
  def get_controller_name
    case controller_name
    when "registrations", "sessions", "confirmations", "omniauth_callbacks", "passwords", "unlocks"
      return "users"
    else
      return controller_name
    end
  end
  
  def get_searchable_columns_names
    @model = to_model(controller_name)
    @searchable_columns = []
    @model.columns.each do |column|
      if is_searchable?(column.name, controller_name)
        @searchable_columns << column
      end
    end
    odd = @searchable_columns.count.even? ? 0 : 1
    @left_fields = @searchable_columns.first((@searchable_columns.count + odd)/2)
    @right_fields = @searchable_columns.last((@searchable_columns.count)/2)
  end
  
  def get_indexable_columns_names
    @model = to_model(controller_name)
    @indexable_columns = []
    @model.columns.each do |column|
      if is_indexable?(column.name, controller_name)
        @indexable_columns << [t("#{controller_name}.index.#{column.name}"), "#{column.name}"]
      end
    end
  end
  
  def is_searchable?(column_name, controller_name)   
    not_searchable_columns = [
      "controller_name", "controller", "condition", "search_by_or_and", "commit", "action", "utf8", "action", "page", "per_page", "search_by", "order_by", "sort_by", "search_by"
    ]
    if controller_name == "users"
      not_searchable_columns = not_searchable_columns + [ 
        "encrypted_password", 
        "reset_password_token", 
        "reset_password_sent_at",
        "remember_created_at", 
        "confirmation_token", 
        "current_sign_in_at", 
        "current_sign_in_ip", 
        "last_sign_in_ip", 
        "authentication_token", 
        "confirmed_at", 
        "confirmation_sent_at", 
        "unconfirmed_email", 
        "failed_attempts", 
        "unlock_token", 
        "locked_at",
        "logo_file_name",
        "logo_content_type",
        "logo_file_size",
        "logo_updated_at",
        "sign_in_count",
        "last_sign_in_at",
      ]
    end
    #INSERT NEW NOT SERCHEABLE COLUMNS
    if controller_name == 'app_add_ons'
      not_searchable_columns = not_searchable_columns + [
        '']
    end


    searchable = true
    not_searchable_columns.each do |not_searchable_column|
      if column_name == not_searchable_column
        searchable = false
        break
      end
    end
    return searchable
  end
  
  def is_indexable?(column_name, controller_name) 
    not_indexable_columns = [
      "controller_name", "controller", "condition", "search_by_or_and", "commit", "action", "utf8", "action", "page", "per_page", "search_by", "order_by", "sort_by", "search_by"
    ]
    if controller_name == "users"
      not_indexable_columns = not_indexable_columns + [
        "username",
        "encrypted_password", 
        "reset_password_token", 
        "reset_password_sent_at",
        "remember_created_at", 
        "confirmation_token", 
        "current_sign_in_at", 
        "current_sign_in_ip", 
        "last_sign_in_ip", 
        "authentication_token", 
        "confirmed_at", 
        "confirmation_sent_at", 
        "unconfirmed_email", 
        "failed_attempts", 
        "unlock_token", 
        "locked_at",
        "logo_file_name",
        "logo_content_type",
        "logo_file_size",
        "logo_updated_at",
        "sign_in_count",
        "last_sign_in_at",
        "address1",
        "address2",
        "phone2",
        "fax"
      ]
    end
    #INSERT NEW NOT INDEXABLE COLUMNS
    if controller_name == 'app_add_ons'
      not_indexable_columns = not_indexable_columns + [
        '']
    end


    indexable = true
    not_indexable_columns.each do |not_indexable_column|
      if column_name == not_indexable_column
        indexable = false
        break
      end
    end
    return indexable
  end 
  
  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end
  def mx_states
    [
      ["Aguascalientes"],
      ["Baja California"],
      ["Baja California Sur"],
      ["Campeche"],
      ["Chiapas"],
      ["Chihuahua"],
      ["Coahuila"],
      ["Colima"],
      ["Distrito Federal"],
      ["Durango"],
      ["Estado de M??xico"],
      ["Guanajuato"],
      ["Guerrero"],
      ["Hidalgo"],
      ["Jalisco"],
      ["Michoac??n"],
      ["Morelos"],
      ["Nayarit"],
      ["Nuevo Le??n"],
      ["Oaxaca"],
      ["Puebla"],
      ["Quer??taro"],
      ["Quintana Roo"],
      ["San Luis Potos??"],
      ["Sinaloa"],
      ["Sonora"],
      ["Tabasco"],
      ["Tamaulipas"],
      ["Tlaxcala"],
      ["Veracruz"],
      ["Yucat??n"],
      ["Zacatecas"],
      ["Otro"]
    ]
  end
  
  def belongs_to_models(model)
    @belongs_to_models = []
    if is_model?(model)
      @model = to_model(model)
      belongs_to_models = @model.reflect_on_all_associations(:belongs_to).map(&:name)
      belongs_to_models.each do |model|
        if is_model?(model)
          @belongs_to_models << {'name' => to_model_name(model), 'human_name' => I18n.t("activerecord.models.#{model.to_s}")}
        end
      end
    end
    return @belongs_to_models
  end 
  
  def show_quick_search_form?
    if ["index"].include?(action_name) and is_model?(controller_name) and can? :index, to_model(controller_name)
      return true
    else
      return false
    end  
  end
  
  def show_action_links?
    if ["new", "create", "edit", "update", "index", "show", "destroy"].include?(action_name) and is_model?(controller_name)
      return true
    else
      return false
    end 
  end
  
  def has_index?(model)
    model = to_controller_name(model)
    if (Rails.application.routes.recognize_path model).to_s.include? ("index") and File.exists?("#{Rails.root}/app/views/#{model}/index.html.erb")
      return true
    else
      return false
    end
  rescue
    return false
  end
  
  def is_model?(model)
    if File.exist?("app/models/#{to_model_file_name(model)}.rb")
      return true
    else
      return false
    end
  rescue
    return false
  end
  
  def to_model(model)
    name = eval("#{to_model_name(model)}")
    return name
  rescue
    "Error on to_model: " + model.to_s
  end
  def to_model_name(model)
    name = model.to_s.gsub("_id", "").singularize.camelize
    return name
  rescue
    "Error on to_model_name: " + model.to_s
  end
  def to_model_file_name(model)
    name = model.to_s.gsub("_id", "").tableize.singularize
    return name
  rescue
    "Error on to_model_file_name: " + model.to_s
  end
  def to_controller_name(model)
    name = model.to_s.gsub("_id", "").tableize
    return name
  rescue
    "Error on to_controller_name: " + model.to_s
  end
  
end
