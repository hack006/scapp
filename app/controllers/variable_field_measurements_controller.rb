class VariableFieldMeasurementsController < ApplicationController
  before_action :set_variable_field_measurement, only: [:show, :edit, :update, :destroy]

  # GET /variable_field_measurements
  # GET /variable_field_measurements.json
  def index
    @variable_field_measurements = VariableFieldMeasurement.all
  end

  # GET /variable_field_measurements/1
  # GET /variable_field_measurements/1.json
  def show
  end

  # GET /variable_field_measurements/new
  def new
    @variable_field_measurement = VariableFieldMeasurement.new
  end

  # GET /variable_field_measurements/1/edit
  def edit
  end

  # POST /variable_field_measurements
  # POST /variable_field_measurements.json
  def create
    @variable_field_measurement = VariableFieldMeasurement.new(variable_field_measurement_params)

    respond_to do |format|
      if @variable_field_measurement.save
        format.html { redirect_to @variable_field_measurement, notice: 'Variable field measurement was successfully created.' }
        format.json { render action: 'show', status: :created, location: @variable_field_measurement }
      else
        format.html { render action: 'new' }
        format.json { render json: @variable_field_measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variable_field_measurements/1
  # PATCH/PUT /variable_field_measurements/1.json
  def update
    respond_to do |format|
      if @variable_field_measurement.update(variable_field_measurement_params)
        format.html { redirect_to @variable_field_measurement, notice: 'Variable field measurement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @variable_field_measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variable_field_measurements/1
  # DELETE /variable_field_measurements/1.json
  def destroy
    @variable_field_measurement.destroy
    respond_to do |format|
      format.html { redirect_to variable_field_measurements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable_field_measurement
      @variable_field_measurement = VariableFieldMeasurement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variable_field_measurement_params
      params.require(:variable_field_measurement).permit(:measured_at, :locality, :string_value, :int_value)
    end
end
