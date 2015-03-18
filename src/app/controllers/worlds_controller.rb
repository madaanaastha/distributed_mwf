class WorldsController < ApplicationController
  include WorldsHelper
  require 'json'
  require 'rubygems'
  before_action :set_world, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /worlds
  # GET /worlds.json
  def index
    @worlds = World.all
  end

  # GET /worlds/1
  # GET /worlds/1.json
  def show
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
    @location = World.find(Uri.get_record(@uri.to_s).local_id)
    @types = []
    res=World.all.select("world_uri", "name").collect
    res.each { |r| @types << {uri: r.world_uri, name: r.name} }
    @world = World.new
    render 'new'
  end

  # GET /worlds/new
  def new
    @world = World.new
  end

  def select_schema
    @uri = URI(params[:uri])
    puts params.inspect
    @world = World.find(Uri.get_record(@uri.to_s).local_id)
    @tables = get_all_tables(@world.world_uri, @world.superclass_uri)
    #render text:@tables.inspect
  end

  def populate_table_form
    @world_uri = URI(params[:uri])
    @world = World.find(Uri.get_record(@world_uri.to_s).local_id)
    @schema_uri = URI(params['schema-name'])
    @schema = SchemaTable.find_by_uri(@schema_uri.to_s)
    @a = eval(@schema.hash_store)
    @vals = {}
    @a.keys.each do |k|
      unless(@a[k]=='number' || @a[k]=='string' || @a[k]=='datetime')
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

  def populate_table
    @world_uri = URI(params['world-uri'])
    @schema_uri = URI(params['schema-uri'])
    @schema = SchemaTable.find_by_uri(@schema_uri.to_s)
    participation_flag = false
    participant = nil
    @a = eval(@schema.hash_store)
    h = {}
    @a.keys.each do |key|
      h[key] = params[key.to_s]
      if(key.to_s == @schema.role_player_column_name)
        participation_flag = true
        participant = h[key]
      end
    end
    dt = DataTuple.create_data_tuple(@world_uri.to_s, @schema_uri.to_s, h)
    if(participation_flag)
      w = WorldParticipation.new
      w.participating_world_uri = participant
      w.container_table_uri = @schema_uri.to_s
      w.container_world_uri = @world_uri.to_s
      w.verified = false
      w.save!
    end
    u = Uri.get_record(@world_uri.to_s)
    if(u['uri_type']=='World')
      w = World.find_by_world_uri(@world_uri.to_s)
      w.increment_version
    end
    redirect_to @world_uri.to_s
  end

  def import_world
    @uri = URI(params[:uri])
    @world = World.find(Uri.get_record(@uri.to_s).local_id)
    @imported_world_uris = get_all_imports(@uri.to_s, @world.superclass_uri)
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
      u = Uri.get_record(@uri.to_s)
      if(u.uri_type=='World')
        w = World.find_by_world_uri(@uri.to_s)
        w.increment_version
      end

      redirect_to @uri.to_s
    else
      head(status=401)
    end

  end

  def autocomplete
    str = "#{params[:term]}%"
    worlds = Uri.all.where("uri_type='World' and name like ?", str).pluck(:slug)
    #arr = worlds.collect([]){|a, w| a<< w.slug}
    render text: worlds.to_json
  end

  # GET /worlds/add_schema
  def add_schema
    @uri = URI(params[:uri])
    @world = World.find(Uri.get_record(@uri.to_s).local_id)
  end

  # GET /worlds/edit_schema
  def edit_schema
    @uri = URI(params[:uri])
    @schema_name = params[:schema_name]
    @world = World.find(Uri.get_record(@uri.to_s).local_id)
    @imported_world_uris = get_all_imports(@uri.to_s, @world.superclass_uri)
  end

  def save_schema
    #puts params.inspect
    @world_uri = params[:world_uri]
    if (WorldAdmin.has_visibility_privilege?(@world_uri.to_s, session[:user_uri]) && WorldAdmin.has_frame_level_privilege?(@world_uri.to_s, session[:user_uri]))

      @schema_name = params[:schema_name]
      schema_columns = params[:columnDetails]
      @key_column = (if params[:cb].nil?
                       nil
                     else params[:cb]
                     end)
      schema_columns = JSON.parse(schema_columns)
      h = {}
      schema_columns.each do |col|
        h[col["colName"].to_sym]=col["colType"];
      end unless schema_columns.nil? || schema_columns.empty?
      host_port = request.host_with_port
      host = host_port.split(":").first
      port = host_port.split(":").last
      puts h.inspect
      SchemaTable.create_schema_with_uri(@schema_name, @world_uri, @key_column, h, host, port)
      u = Uri.get_record(@world_uri.to_s)
      if(u.uri_type=='World')
        w = World.find_by_world_uri(@world_uri.to_s)
        w.increment_version
      end
      redirect_to "#{params[:world_uri]}"
    else
      head(status=401)
    end
  end

  # GET /worlds/1/edit
  def edit
  end

  # POST /worlds
  # POST /worlds.json
  def create
    superclass_uri = params["type-parent"]
    container_uri = params["location-parent"]
    world_name = params["name"]
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
      w = World.create_world_with_uri(world_name, superclass_uri, container_uri, description, nil, options, nil, nil, nil, hostname, port)

      puts w.world_uri

      redirect_to w.world_uri
    else
      head(status=401)
    end
    # @world = World.new(world_params)
    #
    # respond_to do |format|
    #   if @world.save
    #     format.html { redirect_to @world, notice: 'World was successfully created.' }
    #     format.json { render :show, status: :created, location: @world }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @world.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /worlds/1
  # PATCH/PUT /worlds/1.json
  def update
    respond_to do |format|
      if @world.update(world_params)
        format.html { redirect_to @world, notice: 'World was successfully updated.' }
        format.json { render :show, status: :ok, location: @world }
      else
        format.html { render :edit }
        format.json { render json: @world.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /worlds/1
  # DELETE /worlds/1.json
  def destroy
    @world.destroy
    respond_to do |format|
      format.html { redirect_to worlds_url, notice: 'World was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_world
    @world = World.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def world_params
    params.require(:world).permit(:name, :superclass_uri, :container_uri, :description, :attrs, :options, :world_uri_id, :home_location_uri_id, :image, :url, :access_rules, :version)
  end

end
