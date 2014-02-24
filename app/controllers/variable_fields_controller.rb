class VariableFieldsController < ApplicationController
  before_action :set_variable_field, only: [:show, :edit, :update, :destroy]

  # GET /variable_fields
  # GET /variable_fields.json
  def index
    @variable_fields = VariableField.public_or_owned_by(current_user.id)
  end

  # GET /variable_fields/1
  # GET /variable_fields/1.json
  def show
  end

  # GET /variable_fields/new
  def new
    @variable_field = VariableField.new
    @variable_field_categories_accessible = VariableFieldCategory.owned_by_user_or_public(current_user.id)
  end

  # GET /variable_fields/1/edit
  def edit
    @variable_field_categories_accessible = VariableFieldCategory.owned_by_user_or_public(current_user.id)
    @confirmation = @variable_field.confirmation_token
  end

  # POST /variable_fields
  # POST /variable_fields.json
  def create
    @variable_field = VariableField.new(variable_field_params)
    @variable_field.user = current_user

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


    @user = User.friendly.find(params[:user_id])
    @variable_fields = Hash.new()
    VariableField.with_measurements_for(@user).order_by_categories.group('variable_fields.id').each do |vf|
      category = vf.variable_field_category.name unless vf.variable_field_category.blank?
      category ||= 'Uncategorized'

      @variable_fields[category] ||= { detail: nil, items: []}
      @variable_fields[category][:detail] ||= vf.variable_field_category

      variable_field = { field: vf,
                         latest_measurement: vf.latest_measurement(@user),
                         worst_measurement: vf.worst_measurement(@user),
                         best_measurement: vf.best_measurement(@user)}
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
    # TODO implement

  end

  # Return graph data in JSON
  #
  # @param [int] id Variable field id
  def user_variable_graph
    # TODO implement user security policy
    # get latest 20 measurements
    @variable_field_measurements = VariableField.find(params[:id]).latest_measurements(1, 20, current_user).map do |vfm|
      {measured_at: vfm.measured_at.strftime('%Y-%m-%d %H:%M'), int_value: vfm.int_value, location: vfm.locality}
    end

    respond_to do |format|
      #format.js { render partial: 'variable_fields/ajax/summary_graph' }
      format.js { render json: {refresh_id: "chart-#{params[:id]}", data: @variable_field_measurements}.to_json }
    end
  end

  # Return table data in JSON
  #
  # @param [int] id Variable field id
  def user_variable_table
    # TODO implement user security policy
    # get latest 20 measurements
    @variable_field_measurements = VariableField.find(params[:id]).latest_measurements(1, 20, current_user).map do |vfm|
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable_field
      @variable_field = VariableField.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variable_field_params
      params.require(:variable_field).permit(:name, :description, :unit, :higher_is_better, :is_numeric,
                                             :variable_field_category_id, :modification_confirmation)
    end
end
