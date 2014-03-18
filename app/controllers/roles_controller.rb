class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :set_icon  
  before_filter :get_data, :except => [:show, :destroy]
  load_and_authorize_resource except: [:create]
  
  # GET /roles
  def index
  end

  # GET /roles/1
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new#DO NO DELETE THIS COMMENT
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to @role, notice:  t("actions.created.male",  model: t("activerecord.models.#{controller_name.singularize}").downcase)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /roles/1
  def update
    if @role.update(role_params)
      redirect_to @role, notice:  t("actions.updated.male",  model: t("activerecord.models.#{controller_name.singularize}").downcase)
    else
      render action: 'edit'
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy
    redirect_to roles_url, notice:  t("actions.destroyed.male",  model: t("activerecord.models.#{controller_name.singularize}").downcase)
  end

  def destroy_multiple
    if params[:roles]
      Role.destroy(params[:roles])
      redirect_to roles_url, notice:  t("actions.multiple_destroyed.male",  model: t("activerecord.models.#{controller_name}").downcase)    
    else
      redirect_to roles_url, notice:  t("messages.error.you_must_select_at_least_one.male",  model: t("activerecord.models.#{controller_name.singularize}").downcase)    
    end
  end

  def get_data
    data
  end

  def set_icon
    @icon = "icon"
  end
      
  def generate_random_data
    generate_data
    redirect_to eval("#{params[:controller_name]}_path"), notice:  t("actions.created.male",  model: t("activerecord.models.#{controller_name}").downcase)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def role_params
    params.require(:role).permit(:name, :protected, :superadmin, :administrator, :default_user, :guess, :custom, :description)#DO NO DELETE THIS COMMENT
  end
end
      