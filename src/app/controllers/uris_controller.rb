class UrisController < ApplicationController
  before_action :set_uri, only: [:show, :edit, :update, :destroy, :show_slug]

  # GET /uris
  # GET /uris.json
  def index
    @uris = Uri.all
  end

  # GET /uris/1
  # GET /uris/1.json
  def show
  end

  # GET /uris/Concept
  # GET /uris/Concept.json
  def show_slug
  #TODO: remove this method once testing is done
    @w = nil
    unless (@uri.nil?)
      if (@uri.uri_type == "World" || @uri.uri_type == "WorldInstance")
        model = Object.const_get(@uri.uri_type)
        @w = model.find(@uri.local_id)
        @a = WorldAdmin.is_administrator?(@uri.get_uri, session[:user_uri])
      end
    end
  end

  # GET /uris/new
  def new
    @uri = Uri.new
  end

  # GET /uris/1/edit
  def edit
  end

  # POST /uris
  # POST /uris.json
  def create
    @uri = Uri.new(uri_params)

    respond_to do |format|
      if @uri.save
        format.html { redirect_to @uri, notice: 'Uri was successfully created.' }
        format.json { render :show, status: :created, location: @uri }
      else
        format.html { render :new }
        format.json { render json: @uri.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uris/1
  # PATCH/PUT /uris/1.json
  def update
    respond_to do |format|
      if @uri.update(uri_params)
        format.html { redirect_to @uri, notice: 'Uri was successfully updated.' }
        format.json { render :show, status: :ok, location: @uri }
      else
        format.html { render :edit }
        format.json { render json: @uri.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uris/1
  # DELETE /uris/1.json
  def destroy
    @uri.destroy
    respond_to do |format|
      format.html { redirect_to uris_url, notice: 'Uri was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_uri
    @uri = Uri.find_by_slug(params[:slug])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def uri_params
    params.require(:uri).permit(:host, :port, :uri_type, :local_id, :name, :slug, :is_external)
  end
end
