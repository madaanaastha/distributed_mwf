class WorldImportsController < ApplicationController
  before_action :set_world_import, only: [:show, :edit, :update, :destroy]

  # GET /world_imports
  # GET /world_imports.json
  def index
    @world_imports = WorldImport.all
  end

  # GET /world_imports/1
  # GET /world_imports/1.json
  def show
  end

  # GET /world_imports/new
  def new
    @world_import = WorldImport.new
  end

  # GET /world_imports/1/edit
  def edit
  end

  # POST /world_imports
  # POST /world_imports.json
  def create
    @world_import = WorldImport.new(world_import_params)

    respond_to do |format|
      if @world_import.save
        format.html { redirect_to @world_import, notice: 'World import was successfully created.' }
        format.json { render :show, status: :created, location: @world_import }
      else
        format.html { render :new }
        format.json { render json: @world_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /world_imports/1
  # PATCH/PUT /world_imports/1.json
  def update
    respond_to do |format|
      if @world_import.update(world_import_params)
        format.html { redirect_to @world_import, notice: 'World import was successfully updated.' }
        format.json { render :show, status: :ok, location: @world_import }
      else
        format.html { render :edit }
        format.json { render json: @world_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /world_imports/1
  # DELETE /world_imports/1.json
  def destroy
    @world_import.destroy
    respond_to do |format|
      format.html { redirect_to world_imports_url, notice: 'World import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_world_import
      @world_import = WorldImport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def world_import_params
      params.require(:world_import).permit(:import_to_uri, :import_from_uri)
    end
end
