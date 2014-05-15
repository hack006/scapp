class VariableFieldCategoriesController < ApplicationController
  before_action :set_variable_field_category, only: [:show, :edit, :update, :destroy]

  authorize_resource

  # GET /variable_field_categories
  # GET /variable_field_categories.json
  def index
    # @15.1
    if is_admin?
      @variable_field_categories = VariableFieldCategory.all.page(params[:page])
    else
      @variable_field_categories = VariableFieldCategory.owned_by_user_or_public(current_user).page(params[:page])
    end
  end

  # GET /variable_field_categories/1
  # GET /variable_field_categories/1.json
  def show
  end

  # GET /variable_field_categories/new
  def new
    @variable_field_category = VariableFieldCategory.new
    @variable_field_category.user = current_user
  end

  # GET /variable_field_categories/1/edit
  def edit
  end

  # POST /variable_field_categories
  # POST /variable_field_categories.json
  def create
    # only admin can manipulate all fields
    if is_admin?
      @variable_field_category = VariableFieldCategory.new(variable_field_category_params_admin)
    else
      @variable_field_category = VariableFieldCategory.new(variable_field_category_params)
      @variable_field_category.is_global = false
      @variable_field_category.user = current_user
    end

    respond_to do |format|
      if @variable_field_category.save
        format.html { redirect_to variable_field_categories_path, notice: t('vfc.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @variable_field_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @variable_field_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variable_field_categories/1
  # PATCH/PUT /variable_field_categories/1.json
  def update
    # only admin can manipulate all fields
    respond_to do |format|
      if (is_admin? && @variable_field_category.update(variable_field_category_params_admin)) ||  @variable_field_category.update(variable_field_category_params)
        format.html { redirect_to variable_field_categories_path, notice: t('vfc.controller.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @variable_field_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variable_field_categories/1
  # DELETE /variable_field_categories/1.json
  def destroy
    begin
      @variable_field_category.destroy!
    rescue StandardError => e
      respond_to do |format|
        format.html { redirect_to variable_field_categories_path, alert: t('vfc.controller.can_not_delete_dependent_vf_exists') }
        format.json { render json: {error: 'Error! Dependent VF exists.'}.to_json, status: :unprocessable_entity }
      end
      return
    end

    respond_to do |format|
      format.html { redirect_to variable_field_categories_url, notice: t('vfc.controller.successfully_removed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable_field_category
      @variable_field_category = VariableFieldCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variable_field_category_params
      params.require(:variable_field_category).permit(:name, :rgb, :description)
    end

    def variable_field_category_params_admin
      params.require(:variable_field_category).permit(:name, :rgb, :description, :is_global, :user_id)
    end
end
