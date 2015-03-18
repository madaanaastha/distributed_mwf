class ProxyWorldsController < ApplicationController
  before_action :set_proxy_world, only: [:show, :edit, :update, :destroy]

  # GET /proxy_worlds
  # GET /proxy_worlds.json
  def index
    @proxy_worlds = ProxyWorld.all
  end

  # GET /proxy_worlds/1
  # GET /proxy_worlds/1.json
  def show
  end

  # GET /proxy_worlds/new
  def new
    @proxy_world = ProxyWorld.new
  end

  # GET /proxy_worlds/1/edit
  def edit
  end

  # POST /proxy_worlds
  # POST /proxy_worlds.json
  def create
    @proxy_world = ProxyWorld.new(proxy_world_params)

    respond_to do |format|
      if @proxy_world.save
        format.html { redirect_to @proxy_world, notice: 'Proxy world was successfully created.' }
        format.json { render :show, status: :created, location: @proxy_world }
      else
        format.html { render :new }
        format.json { render json: @proxy_world.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proxy_worlds/1
  # PATCH/PUT /proxy_worlds/1.json
  def update
    respond_to do |format|
      if @proxy_world.update(proxy_world_params)
        format.html { redirect_to @proxy_world, notice: 'Proxy world was successfully updated.' }
        format.json { render :show, status: :ok, location: @proxy_world }
      else
        format.html { render :edit }
        format.json { render json: @proxy_world.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proxy_worlds/1
  # DELETE /proxy_worlds/1.json
  def destroy
    @proxy_world.destroy
    respond_to do |format|
      format.html { redirect_to proxy_worlds_url, notice: 'Proxy world was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proxy_world
      @proxy_world = ProxyWorld.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proxy_world_params
      params.require(:proxy_world).permit(:world_uri_id, :proxy_world_uri_id)
    end
end
