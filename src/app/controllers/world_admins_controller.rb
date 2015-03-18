class WorldAdminsController < ApplicationController
  include WorldsHelper
  before_action :set_world_admin, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /world_admins
  # GET /world_admins.json
  def index
    @world_admins = WorldAdmin.all
  end

  def check_if_admin
    world_uri = params[:world_uri]
    user_uri = params[:user_uri]
    render text: (WorldAdmin.is_administrator?(world_uri, user_uri)).to_json and return
  end

  # GET /world_admins/1
  # GET /world_admins/1.json
  def show
  end

  # GET /world_admins/new
  def new
    @world_admin = WorldAdmin.new
  end

  # GET /world_admins/1/edit
  def edit
  end

  # POST /world_admins
  # POST /world_admins.json
  def create
    @world_admin = WorldAdmin.new(world_admin_params)

    respond_to do |format|
      if @world_admin.save
        format.html { redirect_to @world_admin, notice: 'World admin was successfully created.' }
        format.json { render :show, status: :created, location: @world_admin }
      else
        format.html { render :new }
        format.json { render json: @world_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /world_admins/1
  # PATCH/PUT /world_admins/1.json
  def update
    respond_to do |format|
      if @world_admin.update(world_admin_params)
        format.html { redirect_to @world_admin, notice: 'World admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @world_admin }
      else
        format.html { render :edit }
        format.json { render json: @world_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /world_admins/1
  # DELETE /world_admins/1.json
  def destroy
    @world_admin.destroy
    respond_to do |format|
      format.html { redirect_to world_admins_url, notice: 'World admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def view_access_rules
    @world=World.find_by_world_uri(params[:world_uri])
  end

  def add_access_rules
    @uri = URI(params[:world_id])
    @uritype = Uri.get_record(params[:world_id]).uri_type
    if @uritype == "World"
      @world=World.find_by_world_uri(params[:world_id])
      @imports_uris = get_all_imports(@uri.to_s, @world.superclass_uri)
    else
      @world_instance=WorldInstance.find_by_world_instance_uri(params[:world_id])
      @imports_uris = get_all_imports(@uri.to_s, @world_instance.superclass_uri)
    end
  end

  def list_roles_to_add_access_rules
    @uritype = Uri.get_record(params[:world_uri]).uri_type
    if @uritype == "World"
      @world=World.find_by_world_uri(params[:world_uri])
    else
      @world_instance=WorldInstance.find_by_world_instance_uri(params[:world_uri])
    end
    @importtype = Uri.get_record(params[:list_imports]).uri_type
    if @importtype == "World"
      @import_uri = World.find(Uri.get_record(params[:list_imports].to_s).local_id)
    else
      @import_uri = WorldInstance.find(Uri.get_record(params[:list_imports].to_s).local_id)
    end
    @superclass_import_uri = @import_uri.superclass_uri
    @roles = []
    @roles = get_all_roles(@import_uri.world_uri, @superclass_import_uri)
  end

  def submit_access_rules
    @uritype = Uri.get_record(params[:world_uri]).uri_type
    if @uritype == "World"
      @world=World.find_by_world_uri(params[:world_uri])
    else
      @world=WorldInstance.find_by_world_instance_uri(params[:world_uri])
    end
    if params.has_key?(:package)
      options = {visibility: false, privilege: false, frame: false, structure: false, data: false}
      options[:visibility] = true if (params["package"].include?("visibility"))
      options[:privilege] = true if (params["package"].include?("privilege"))
      options[:frame] = true if (params["package"].include?("frame"))
      options[:structure] = true if (params["package"].include?("structure"))
      options[:data] = true if (params["package"].include?("data"))
    end
    rule = "{#{options.to_s}=>#{params[:role_name]}(#{params[:role_type_text]},#{params[:role_location_text]})}"
    access_rules = {}
    access_rules = eval (@world.access_rules)
    if access_rules == nil
      access_rules = {}
    end
    packagename = params[:privilege_package_name_text]
    access_rules[packagename] = rule
    @world.access_rules = access_rules.to_s()
    @world.save!
    @world.increment_version
    redirect_to params[:world_uri]
  end

  def check_package_name
    code = :ok
    @uritype = Uri.get_record(params[:world_id]).uri_type
    if @uritype == "World"
      @world=World.find_by_world_uri(params[:world_id])
    else
      @world=WorldInstance.find_by_world_instance_uri(params[:world_uri])
    end
    access_rules = eval (@world.access_rules)
    if access_rules != nil
      if access_rules.has_key?("#{params[:privilege_package_name_text]}")
        code = :bad_request
      end
    end
    head code
  end

  def get_type_location_of_role
    arr = []
    role_uri = params[:role_uri]
    if role_uri != "" then
      t = SchemaTable.find_by_uri(role_uri)
      arr[0] = t.world_uri
      arr[1] = World.find_by_world_uri(t.world_uri).container_uri
    else
      arr[0]=""
      arr[1]=""
    end
    render text: arr.to_json
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_world_admin
    @world_admin = WorldAdmin.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def world_admin_params
    params.require(:world_admin).permit(:world_uri_id, :admin_uri_id)
  end
end
