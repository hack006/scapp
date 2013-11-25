class VariableFieldSportsController < ApplicationController
  before_action :set_variable_field_sport, only: [:show, :edit, :update, :destroy]

  # GET /variable_field_sports
  # GET /variable_field_sports.json
  def index
    @variable_field_sports = VariableFieldSport.all
  end

  # GET /variable_field_sports/1
  # GET /variable_field_sports/1.json
  def show
  end

  # GET /variable_field_sports/new
  def new
    @variable_field_sport = VariableFieldSport.new
  end

  # GET /variable_field_sports/1/edit
  def edit
  end

  # POST /variable_field_sports
  # POST /variable_field_sports.json
  def create
    @variable_field_sport = VariableFieldSport.new(variable_field_sport_params)

    respond_to do |format|
      if @variable_field_sport.save
        format.html { redirect_to @variable_field_sport, notice: 'Variable field sport was successfully created.' }
        format.json { render action: 'show', status: :created, location: @variable_field_sport }
      else
        format.html { render action: 'new' }
        format.json { render json: @variable_field_sport.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variable_field_sports/1
  # PATCH/PUT /variable_field_sports/1.json
  def update
    respond_to do |format|
      if @variable_field_sport.update(variable_field_sport_params)
        format.html { redirect_to @variable_field_sport, notice: 'Variable field sport was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @variable_field_sport.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variable_field_sports/1
  # DELETE /variable_field_sports/1.json
  def destroy
    @variable_field_sport.destroy
    respond_to do |format|
      format.html { redirect_to variable_field_sports_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable_field_sport
      @variable_field_sport = VariableFieldSport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variable_field_sport_params
      params.require(:variable_field_sport).permit(:name)
    end
end
