class WorldInstancesController < ApplicationController
  protect_from_forgery
  before_action :set_world_instance, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  # GET /world_instances
  # GET /world_instances.json
  include WorldInstancesHelper
  include WorldsHelper
  def index
    @world_instances = WorldInstance.all
  end

  def subclass
    @uri = URI(params[:uri])
    @subclass = true
    @locations = []
    @type = World.find(Uri.get_record(@uri.to_s).local_id)
    res = World.all.select("world_uri", "name")
    res.each do |r|
      @locations<<{uri: r.world_uri, name: r.name}
    end
    res = WorldInstance.all.select("world_instance_uri", "name")
    res.each do |r|
      @locations<<{uri: r.world_instance_uri, name: r.name}
    end
    @world = World.new
    render 'new'
  end

  def contain
    @uri = URI(params[:uri])
    @subclass = false
    if Uri.get_record(@uri.to_s).uri_type.eql?("World")
      @location = World.find(Uri.get_record(@uri.to_s).local_id)
    else
      @location = WorldInstance.find(Uri.get_record(@uri.to_s).local_id)
    end
    @types = []
    res=World.all.select("world_uri", "name").collect
    res.each { |r| @types << {uri: r.world_uri, name: r.name} }
    @world = World.new
    render 'new'
  end

  # GET /world_instances/1
  # GET /world_instances/1.json
  def show
  end

  # GET /world_instances/new
  def new
    @world_instance = WorldInstance.new
  end

  # GET /world_instances/1/edit
  def edit
  end

  # POST /world_instances
  # POST /world_instances.json
  def create
    world_name = params["name"]
    superclass_uri = params["type-parent"]
    container_uri = params["location-parent"]
    description = params["description"]
    if params.has_key?(:options)
      options = {protected: false, locked: false}
      options[:protected] = true if (params["options"].include?("protected"))
      options[:locked] = true if (params["options"].include?("locked"))
    end
    host_port = request.host_with_port
    hostname = host_port.split(":").first
    port = host_port.split(":").last

    if (WorldAdmin.has_visibility_privilege?(superclass_uri, session[:user_uri]) && WorldAdmin.has_frame_level_privilege?(container_uri, session[:user_uri]))
      w = WorldInstance.create_world_instance_with_uri(world_name, superclass_uri, container_uri, description, nil, options, nil, nil, nil, hostname, port)

      puts w.world_instance_uri
      redirect_to w.world_instance_uri
    else
      head(status=401)
    end

    # @world_instance = WorldInstance.new(world_instance_params)
    #
    # respond_to do |format|
    #   if @world_instance.save
    #     format.html { redirect_to @world_instance, notice: 'World instance was successfully created.' }
    #     format.json { render :show, status: :created, location: @world_instance }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @world_instance.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /world_instances/1
  # PATCH/PUT /world_instances/1.json
  def update
    respond_to do |format|
      if @world_instance.update(world_instance_params)
        format.html { redirect_to @world_instance, notice: 'World instance was successfully updated.' }
        format.json { render :show, status: :ok, location: @world_instance }
      else
        format.html { render :edit }
        format.json { render json: @world_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /world_instances/1
  # DELETE /world_instances/1.json
  def destroy
    @world_instance.destroy
    respond_to do |format|
      format.html { redirect_to world_instances_url, notice: 'World instance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def register_new_user

  end

  def add_new_user
    host_port = request.host_with_port
    hostname = host_port.split(":").first
    port = host_port.split(":").last
    add_user hostname, port, params["name"], params["username"], params["email"], params["password"]
    redirect_to '/'
  end

  def import_world
    @uri = URI(params[:uri])
    @world_instance = WorldInstance.find(Uri.get_record(@uri.to_s).local_id)
    @imported_world_uris = get_all_imports(@uri.to_s, @world_instance.superclass_uri)
  end

  def save_world_import
    @uri = URI(params[:uri])
    @slug = params["world-name"]
    @imported_world_uri = (World.find(Uri.find_by_slug(@slug).local_id)).world_uri
    if (WorldAdmin.has_visibility_privilege?(@uri.to_s, session[:user_uri]) && WorldAdmin.has_frame_level_privilege?(@uri.to_s, session[:user_uri]))
      if WorldImport.where(:import_from_uri => @imported_world_uri, :import_to_uri => @uri.to_s).length == 0
        wi = WorldImport.new
        wi.import_from_uri = @imported_world_uri
        wi.import_to_uri=@uri.to_s
        wi.save!
      end
      redirect_to @uri.to_s
    else
      head(status=401)
    end

  end

  def add_schema
    @uri = URI(params[:uri])
    @world_instance = WorldInstance.find(Uri.get_record(@uri.to_s).local_id)
  end

  def edit_schema
    @uri = URI(params[:uri])
    @schema_name = params[:schema_name]
    @world_instance = WorldInstance.find(Uri.get_record(@uri.to_s).local_id)
    @imported_world_uris = get_all_imports(@uri.to_s, @world_instance.superclass_uri)
  end

  def select_schema
    @uri = URI(params[:uri])
    @world_instance = WorldInstance.find(Uri.get_record(@uri.to_s).local_id)
    @tables = get_all_tables(@world_instance.world_instance_uri, @world_instance.superclass_uri)
    #render text:@tables.inspect
  end

  def populate_table_form
    @world_uri = URI(params[:uri])
    @world_instance = WorldInstance.find(Uri.get_record(@world_uri.to_s).local_id)
    @schema_uri = URI(params['schema-name'])
    @schema = SchemaTable.find_by_uri(@schema_uri.to_s)
    @a = eval(@schema.hash_store)
    @vals = {}
    @a.keys.each do |k|
      unless(k=='number' || k=='string' || k=='datetime')
        uri_str = @a[k]
        arr = get_all_instances(uri_str)
        @vals[k] = arr
      end
    end

    tuples = DataTuple.all.where(world_uri:@world_uri.to_s, schema_uri:@schema_uri.to_s).select(:data_store)
    @datatuples = []
    @datatuples = tuples.inject([]){|arr, tuple| arr<<eval(tuple.data_store)} unless tuples.empty?
    #render text:@datatuples.to_s

  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_world_instance
    @world_instance = WorldInstance.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def world_instance_params
    params.require(:world_instance).permit(:name, :superclass_uri_id, :container_uri_id, :description, :attrs, :options, :world_instance_uri_id, :home_location_uri_id, :image, :url, :access_rules, :version)
  end

end
