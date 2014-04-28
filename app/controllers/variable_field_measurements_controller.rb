class VariableFieldMeasurementsController < ApplicationController
  before_action :set_variable_field_measurement, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource except: [:new_for_user, :create_for_user, :create]

  # GET /variable_field_measurements
  # GET /variable_field_measurements.json
  def index
    # @5.1 - :admin can see all, coach only own VFs and VFs of connected players
    if is_admin?
      @variable_field_measurements = VariableFieldMeasurement.all.page(params[:page])
    elsif is_coach?
      @connected_players = current_user.get_my_relations_with_statuses('accepted', :my_players).map { |r| r.to }
      @variable_field_measurements = VariableFieldMeasurement.
          where('measured_for_id IN (:for, :me) OR measured_by_id = :me', {me: current_user, for: @connected_players}).
          page(params[:page])
    elsif is_player?
      @variable_field_measurements = VariableFieldMeasurement.where('measured_by_id = :user OR measured_for_id = :user',
                                                                    user: current_user).page(params[:page])
    end
  end

  # GET /variable_field_measurements/1
  # GET /variable_field_measurements/1.json
  def show
  end

  # GET /variable_field_measurements/new
  def new
    variable_field = VariableField.find(params[:variable_field_id])

    @variable_field_measurement = VariableFieldMeasurement.new
    @variable_field_measurement.variable_field = variable_field
    @variable_field_measurement.measured_for = current_user
    @variable_field_measurement.measured_by = current_user
    # todo timezone problems
    @variable_field_measurement.measured_at = DateTime.current
  end

  # GET /users/{user_id}/variable_field/{variable_field_id}/add_measurement
  def new_for_user
    # TODO - ADD JS measuring of time for better usage in terain on mobile phones
    authorize! :new_for_user, VariableFieldMeasurement

    @for_user = User.friendly.find(params[:user_id])
    @variable_field = VariableField.find(params[:id])
    @variable_field_measurement = VariableFieldMeasurement.new
    @variable_field_measurement.measured_for = @for_user
    # todo timezone problems
    @variable_field_measurement.measured_at = DateTime.current

    render 'users/variable_fields/measurements/new'
  end

  # GET /variable_field_measurements/1/edit
  def edit
  end

  # POST /variable_field_measurements
  # POST /variable_field_measurements.json
  def create
    @variable_field_measurement = VariableFieldMeasurement.new(variable_field_measurement_params)

    # set VF
    vf = VariableField.find(params[:variable_field_measurement][:variable_field_id])
    @variable_field_measurement.variable_field = vf

    # only :admin and :coach can assign for whom is the measurement
    if (is_admin? || is_coach?) && params[:variable_field_measurement][:measured_for_id]
      @variable_field_measurement.measured_for = User.find(params[:variable_field_measurement][:measured_for_id])
    else
      @variable_field_measurement.measured_for = current_user
    end
    # only :admin can set who has made the measurement
    if is_admin? && params[:variable_field_measurement][:measured_by_id]
      @variable_field_measurement.measured_by = User.find(params[:variable_field_measurement][:measured_by_id])
    else
      @variable_field_measurement.measured_by = current_user
    end

    authorize! :create, @variable_field_measurement

    respond_to do |format|
      if @variable_field_measurement.save
        format.html { redirect_to @variable_field_measurement, notice: t('vfm.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @variable_field_measurement }
      else
        format.html { render action: 'new' }
        format.json { render json: @variable_field_measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /users/{user_id}/variable_field/{variable_field_id}/add_measurement
  def create_for_user
    authorize! :create_for_user, VariableFieldMeasurement

    @variable_field_measurement = VariableFieldMeasurement.new(variable_field_measurement_params)
    @for_user = User.friendly.find(params[:user_id])
    @variable_field = VariableField.find(params[:id])

    @variable_field_measurement.variable_field = @variable_field
    @variable_field_measurement.measured_for = @for_user
    # admin can specify measurer, for others measurer is currently logged in user
    if is_admin? && params[:measured_by]
      @variable_field_measurement.measured_by = User.find(params[:measured_by])
    else
      @variable_field_measurement.measured_by = current_user
    end

    respond_to do |format|
      if @variable_field_measurement.save
        format.html { redirect_to @variable_field_measurement, notice: t('vfm.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @variable_field_measurement }
      else
        format.html { render 'users/variable_fields/measurements/new' }
        format.json { render json: @variable_field_measurement.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /variable_field_measurements/1
  # PATCH/PUT /variable_field_measurements/1.json
  def update
    respond_to do |format|
      if @variable_field_measurement.update(variable_field_measurement_params)
        format.html { redirect_to @variable_field_measurement, notice: t('vfm.controller.successfully_updated') }
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
      format.html { redirect_to variable_field_measurements_url, notice: t('vfm.controller.successfully_removed') }
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
