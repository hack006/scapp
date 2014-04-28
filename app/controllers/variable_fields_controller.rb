require 'statsample'

class VariableFieldsController < ApplicationController
  before_action :set_variable_field, only: [:show, :edit, :update, :destroy, :scheduled_lesson_vfm_fill,
                                            :scheduled_lesson_vfm_fill_save, :user_variable_field_detail]
  before_action :set_training_lesson_realization, only: [:scheduled_lesson_add_measurements_vf_select,
                                                         :scheduled_lesson_vfm_fill, :scheduled_lesson_vfm_fill_save]
  load_and_authorize_resource only: [:index, :show, :new, :edit, :update, :destroy]

  # GET /variable_fields
  # GET /variable_fields.json
  def index
    # Only admin can see everything - @4.1
    if is_admin?
      @variable_fields = VariableField.all.page(params[:page])
    else
      @variable_fields = VariableField.global_or_owned_by(current_user.id).page(params[:page])
    end
  end

  # GET /variable_fields/1
  # GET /variable_fields/1.json
  def show
  end

  # GET /variable_fields/new
  def new
    # Todo: only admin can add global variables, more user can have vars with same name
    @variable_field = VariableField.new
    @variable_field_categories_accessible = VariableFieldCategory.owned_by_user_or_public(current_user.id)
  end

  # GET /variable_fields/1/edit
  def edit
    # Global VF can edit only :admin - @4.7
    if @variable_field.is_global? && !is_admin?
      redirect_to variable_fields_path, alert: t('alerts.not_authorized')
      return
    end

    @variable_field_categories_accessible = VariableFieldCategory.owned_by_user_or_public(current_user.id)
    @confirmation = @variable_field.confirmation_token
  end

  # POST /variable_fields
  # POST /variable_fields.json
  def create
    @variable_field = VariableField.new(variable_field_params)
    @variable_field.user = current_user

    # only admin can create global VF
    if is_admin? && params[:variable_field][:is_global] == '1'
      @variable_field.is_global = true
    else
      @variable_field.is_global = false
    end

    respond_to do |format|
      if @variable_field.save
        format.html { redirect_to @variable_field, notice: 'Variable field was successfully created.' }
        format.json { render action: 'show', status: :created, location: @variable_field }
      else
        @variable_field_categories_accessible = VariableFieldCategory.owned_by_user_or_public(current_user.id)
        format.html { render action: 'new' }
        format.json { render json: @variable_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variable_fields/1
  # PATCH/PUT /variable_fields/1.json
  def update
    # Global VF can edit only :admin - @4.7
    if @variable_field.is_global? && !is_admin?
      redirect_to variable_fields_path, alert: t('alerts.not_authorized')
      return
    end

    # Check if we have to use confirmation
    if @variable_field.has_to_confirm_edit?
      unless @variable_field.confirmation_token == params[:variable_field][:modification_confirmation]
        @confirmation = @variable_field.confirmation_token
        @variable_field_categories_accessible = VariableFieldCategory.owned_by_user_or_public(current_user.id)
        flash[:error] = t('variable_field.bad_confirmation')
        # preserve filled in values
        @variable_field.name = params[:variable_field][:name]
        @variable_field.description = params[:variable_field][:description]
        @variable_field.higher_is_better = params[:variable_field][:higher_is_better]
        @variable_field.is_numeric = params[:variable_field][:is_numeric]
        @variable_field.variable_field_category.id = params[:variable_field][:variable_field_category_id]

        render :edit
        return
      end
    end

    respond_to do |format|
      if @variable_field.update(variable_field_params)
        format.html { redirect_to variable_fields_path, notice: 'Variable field was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @variable_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variable_fields/1
  # DELETE /variable_fields/1.json
  def destroy
    begin
      @variable_field.destroy
    rescue ActiveRecord::DeleteRestrictionError => e
      respond_to do |format|
        format.html { redirect_to variable_fields_url, alert: t('variable_field.vf_cant_be_deleted') }
        format.json { render json: {error: t('variable_field.vf_cant_be_deleted')}.to_json, status: :conflict }
      end
      return
    end
    respond_to do |format|
      format.html { redirect_to variable_fields_url }
      format.json { head :no_content }
    end
  end

  # Add new category for variable fields
  #
  # @controller_action
  # @ajax
  def add_category
    @added_category = VariableFieldCategory.new(params.require(:variable_field_category).permit(:name)   )
    @added_category.user_id = current_user.id

    if(@added_category.save!)
      respond_to do |format|
        format.js { render partial: 'variable_fields/ajax/add_category' }
      end
    else
      respond_to do |format|
        format.js { render partial: 'variable_fields/ajax/add_category-failed' }
      end
    end
  end

  # Show user variable fields summary
  #
  # Variable fields are grouped by categories for easier navigation. Only *owner*, *coach*, *partner* and *admin* can
  # view this. Rendered as tabs with options to view (_lazy loaded by ajax_) latest data in graph or data table.
  def user_variable_fields
    # Todo: who can view?
    #   - owner
    #   - coach
    #   - admin
    #   - partner
    authorize! :user_variable_fields, VariableFieldsController

    @user = User.friendly.find(params[:user_id])
    @variable_fields = Hash.new()
    VariableField.with_measurements_for(@user).order_by_categories.group('variable_fields.id').each do |vf|
      category = vf.variable_field_category.name unless vf.variable_field_category.blank?
      category ||= 'Uncategorized'

      @variable_fields[category] ||= { detail: nil, items: []}
      @variable_fields[category][:detail] ||= vf.variable_field_category

      variable_field = { field: vf,
                         latest_measurement: vf.latest_measurement(@user),
                         worst_measurement: vf.is_numeric? ? vf.worst_measurement(@user) : nil,
                         best_measurement: vf.is_numeric? ? vf.best_measurement(@user) : nil}
      @variable_fields[category][:items] << variable_field
    end

    render 'users/variable_fields/list'
  end

  # Show detailed information for specified user variable field
  #
  # Enables viewing large data sets and configure data visualisation in graph.
  #
  # @todo Data exporting in various formats
  # @controller_action
  def user_variable_field_detail
    # TODO authorize! :user_variable_field_detail, VariableFieldsController
    @user = User.friendly.find params[:user_id]

    # if date range filter active, then use it
    begin
      @from_date = params[:from_date].blank? ? nil : Date.strptime(params[:from_date], '%d/%m/%Y')
      @until_date = params[:until_date].blank? ? nil : Date.strptime(params[:until_date], '%d/%m/%Y')
    rescue
      flash[:alert] = t('attendance.controller.bad_date_format')
    end

    # Get variable field measurements
    @user_vfm = VariableFieldMeasurement.
        where(measured_for: @user, variable_field: @variable_field).
        order(measured_at: :asc)
    @user_vfm = @user_vfm.where('measured_at < ?', @until_date.to_datetime) unless @until_date.nil?
    @user_vfm = @user_vfm.where('measured_at > ?', @from_date.to_datetime) unless @from_date.nil?
    @user_vfm_paged = @user_vfm.reorder(measured_at: :desc).page(params[:page])

    # calc avg interval between measurements
    @avg_interval_days = 0
    @avg_interval_days = ((@user_vfm.last.measured_at.to_i - @user_vfm.first.measured_at.to_i) /
        @user_vfm.count / 1.day).round(1) unless @user_vfm.empty?

    # compute graph data only for numeric values
    if @variable_field.is_numeric?
      # CALC stats and graph data if we have any dataset

      @user_vfm_values_vector = (@user_vfm.map{ |v| v.int_value }).to_vector(:scale)
      @graph_data_histogram_names = []
      @graph_data_histogram_values = []

      if @user_vfm.any?
        # compute linear regression line
        regress = Statsample::Regression::Simple.new_from_vectors(@user_vfm.map{ |v| v.measured_at.to_i * 1000 }.to_scale,
                                                                  @user_vfm.map{ |v| v.int_value }.to_scale)
        first_x = @user_vfm.first.measured_at.to_i * 1000
        last_x = @user_vfm.last.measured_at.to_i * 1000

        @histogram_possible = (@user_vfm.count >= 2) ? true : false
        histogram = @user_vfm_values_vector.histogram if @histogram_possible

        # GRAPH DATA
        @regression_line_points = [[first_x, regress.y(first_x)], [last_x, regress.y(last_x)]]
        if @histogram_possible
          histogram.bin.each_with_index do |val, i|
            @graph_data_histogram_names << "#{histogram.range[i].round(2)} - #{histogram.range[i+1].round(2)}"
            @graph_data_histogram_values << val
          end
        end

        @graph_data = @user_vfm.map { |v| { y: v.int_value, x: v.measured_at.to_i * 1000, location: v.locality } }
      end

    end

    render 'users/variable_fields/detail'
  end

  # Return graph data in JSON
  #
  # @param [int] id Variable field id
  # @ajax
  def user_variable_graph
    # TODO authorize! :user_variable_graph, VariableFieldsController
    user = User.friendly.find(params[:user_id])
    # get latest 20 measurements
    @variable_field_measurements = VariableField.find(params[:id]).latest_measurements(1, 20, user).map do |vfm|
      {measured_at: vfm.measured_at.strftime('%Y-%m-%d %H:%M'), location: vfm.locality, x: (vfm.measured_at.to_i * 1000), y: vfm.int_value}
    end

    # older first for graphic library
    @variable_field_measurements.reverse!

    # compute linear regression line
    regress = Statsample::Regression::Simple.new_from_vectors(@variable_field_measurements.map{|v| v[:x]}.to_scale,

                                                              @variable_field_measurements.map{|v| v[:y]}.to_scale)
    first_x = @variable_field_measurements.first[:x]
    last_x = @variable_field_measurements.last[:x]
    @regression_line_points = [[first_x, regress.y(first_x)], [last_x, regress.y(last_x)]]
    respond_to do |format|
      #format.js { render partial: 'variable_fields/ajax/summary_graph' }
      format.js { render json: {refresh_id: "chart-#{params[:id]}", data: {graph: @variable_field_measurements,
                                                                           regression: @regression_line_points}}.to_json }
    end
  end

  # Return table data in JSON
  #
  # @param [int] id Variable field id
  # @ajax
  def user_variable_table
    # TODO authorize! :user_variable_table, VariableFieldsController
    user = User.friendly.find(params[:user_id])
    # get latest 20 measurements
    @variable_field_measurements = VariableField.find(params[:id]).latest_measurements(1, 20, user).map do |vfm|
      [ vfm.measured_at.strftime('%Y-%m-%d %H:%M'), vfm.int_value, vfm.locality, (vfm.measured_by.blank?) ? '-' : vfm.measured_by.name ]
    end

    respond_to do |format|
      #format.js { render partial: 'variable_fields/ajax/summary_graph' }
      format.js do
        render json: {refresh_id: "table-#{params[:id]}",
                      heading: [t('vf.controller.date'), t('vf.controller.value'), t('vf.controller.location'),
                                t('vf.controller.measured_by')],
                      data: @variable_field_measurements}.to_json
      end

    end
  end

  # Selection of VF for training realization measurements
  def scheduled_lesson_add_measurements_vf_select
  # TODO comments
    @variable_fields = VariableField.global_or_owned_by(current_user).order_by_categories

    render 'training_lesson_realizations/variable_fields/scheduled_lesson_add_measurements_vf_select'
  end

  # Fill variable field measurements for present players on training lesssons - FORM
  def scheduled_lesson_vfm_fill
    @measured_at = DateTime.current.full
    @location
    @user_values = { }
    load_present_players_and_attendances

    render 'training_lesson_realizations/variable_fields/scheduled_lesson_vfm_fill'
  end

  # Save filled variable field measurements fo players
  def scheduled_lesson_vfm_fill_save
    @measurement_errors = []

    # hold user entered measurement values
    @user_values = { }
    params[:measurements].each do |user_id, m|
      if @variable_field.is_numeric?
        @user_values[user_id.to_i] = m[:int_value]
      else
        @user_values[user_id.to_i] = m[:string_value]
      end
    end

    @location = params[:locality]
    begin
      @measured_at = Time.strptime(params[:measured_at], '%d/%m/%Y %H:%M')
    rescue
      @measurement_errors << t('vf.scheduled_lesson_fill.bad_date_time')
      load_present_players_and_attendances

      render 'training_lesson_realizations/variable_fields/scheduled_lesson_vfm_fill'
      return
    end

    # Secure that every entry is successfully saved
    ActiveRecord::Base.transaction do
      params[:measurements].each do |user_id, m|
        player = User.find(user_id)
        if @variable_field.is_numeric?
          m = VariableFieldMeasurement.create(locality: @location, measured_at: @measured_at, int_value: m[:int_value].to_f, measured_by: current_user,
                              measured_for: player,variable_field: @variable_field, training_lesson_realization: @training_lesson_realization)
        else
          m = VariableFieldMeasurement.create(locality: @location, measured_at: @measured_at, string_value: m[:string_value], measured_by: current_user,
                              measured_for: player,variable_field: @variable_field, training_lesson_realization: @training_lesson_realization)
        end

        m.errors.to_a.each { |err| @measurement_errors << "#{player.name}: #{err}" }
        raise ActiveRecord::Rollback unless @measurement_errors.empty?
      end
    end

    if @measurement_errors.empty?
      redirect_to @training_lesson_realization, notice: 'Measurements successfully saved.'
    else
      load_present_players_and_attendances

      render 'training_lesson_realizations/variable_fields/scheduled_lesson_vfm_fill'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable_field
      @variable_field = VariableField.find(params[:id])
    end

    def set_training_lesson_realization
      @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:training_lesson_realization_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variable_field_params
      params.require(:variable_field).permit(:name, :description, :unit, :higher_is_better, :is_numeric,
                                             :variable_field_category_id, :modification_confirmation)
    end

    # Load present players (participation = :present) including attendance entry
    def load_present_players_and_attendances
      # Get present players
      @present_players = @training_lesson_realization.attendances.joins(:user).where(participation: :present)

      @variable_field_measurements = {}

      @present_players.each do |a|
        @variable_field_measurements[a.user.id] = { attendance: a, vfm: VariableFieldMeasurement.new(measured_by: current_user, measured_for: a.user) }
      end
    end
end
