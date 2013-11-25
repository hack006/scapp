class VariableFieldUserLevelsController < ApplicationController
  before_action :set_variable_field_user_level, only: [:show, :edit, :update, :destroy]

  # GET /variable_field_user_levels
  # GET /variable_field_user_levels.json
  def index
    @variable_field_user_levels = VariableFieldUserLevel.all
  end

  # GET /variable_field_user_levels/1
  # GET /variable_field_user_levels/1.json
  def show
  end

  # GET /variable_field_user_levels/new
  def new
    @variable_field_user_level = VariableFieldUserLevel.new
  end

  # GET /variable_field_user_levels/1/edit
  def edit
  end

  # POST /variable_field_user_levels
  # POST /variable_field_user_levels.json
  def create
    @variable_field_user_level = VariableFieldUserLevel.new(variable_field_user_level_params)

    respond_to do |format|
      if @variable_field_user_level.save
        format.html { redirect_to @variable_field_user_level, notice: 'Variable field user level was successfully created.' }
        format.json { render action: 'show', status: :created, location: @variable_field_user_level }
      else
        format.html { render action: 'new' }
        format.json { render json: @variable_field_user_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variable_field_user_levels/1
  # PATCH/PUT /variable_field_user_levels/1.json
  def update
    respond_to do |format|
      if @variable_field_user_level.update(variable_field_user_level_params)
        format.html { redirect_to @variable_field_user_level, notice: 'Variable field user level was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @variable_field_user_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variable_field_user_levels/1
  # DELETE /variable_field_user_levels/1.json
  def destroy
    @variable_field_user_level.destroy
    respond_to do |format|
      format.html { redirect_to variable_field_user_levels_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable_field_user_level
      @variable_field_user_level = VariableFieldUserLevel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variable_field_user_level_params
      params.require(:variable_field_user_level).permit(:name)
    end
end
