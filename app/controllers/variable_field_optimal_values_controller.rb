class VariableFieldOptimalValuesController < ApplicationController
  before_action :set_variable_field_optimal_value, only: [:show, :edit, :update, :destroy]

  # GET /variable_field_optimal_values
  # GET /variable_field_optimal_values.json
  def index
    @variable_field_optimal_values = VariableFieldOptimalValue.all
  end

  # GET /variable_field_optimal_values/1
  # GET /variable_field_optimal_values/1.json
  def show
  end

  # GET /variable_field_optimal_values/new
  def new
    @variable_field_optimal_value = VariableFieldOptimalValue.new
  end

  # GET /variable_field_optimal_values/1/edit
  def edit
  end

  # POST /variable_field_optimal_values
  # POST /variable_field_optimal_values.json
  def create
    @variable_field_optimal_value = VariableFieldOptimalValue.new(variable_field_optimal_value_params)

    respond_to do |format|
      if @variable_field_optimal_value.save
        format.html { redirect_to @variable_field_optimal_value, notice: 'Variable field optimal value was successfully created.' }
        format.json { render action: 'show', status: :created, location: @variable_field_optimal_value }
      else
        format.html { render action: 'new' }
        format.json { render json: @variable_field_optimal_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variable_field_optimal_values/1
  # PATCH/PUT /variable_field_optimal_values/1.json
  def update
    respond_to do |format|
      if @variable_field_optimal_value.update(variable_field_optimal_value_params)
        format.html { redirect_to @variable_field_optimal_value, notice: 'Variable field optimal value was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @variable_field_optimal_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variable_field_optimal_values/1
  # DELETE /variable_field_optimal_values/1.json
  def destroy
    @variable_field_optimal_value.destroy
    respond_to do |format|
      format.html { redirect_to variable_field_optimal_values_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable_field_optimal_value
      @variable_field_optimal_value = VariableFieldOptimalValue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variable_field_optimal_value_params
      params.require(:variable_field_optimal_value).permit(:bottom_limit, :upper_limit, :source, :variable_field_id, :variable_field_sport_id, :variable_field_user_level)
    end
end
