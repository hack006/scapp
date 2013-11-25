class VariableFieldCategoriesController < ApplicationController
  before_action :set_variable_field_category, only: [:show, :edit, :update, :destroy]

  # GET /variable_field_categories
  # GET /variable_field_categories.json
  def index
    @variable_field_categories = VariableFieldCategory.all
  end

  # GET /variable_field_categories/1
  # GET /variable_field_categories/1.json
  def show
  end

  # GET /variable_field_categories/new
  def new
    @variable_field_category = VariableFieldCategory.new
  end

  # GET /variable_field_categories/1/edit
  def edit
  end

  # POST /variable_field_categories
  # POST /variable_field_categories.json
  def create
    @variable_field_category = VariableFieldCategory.new(variable_field_category_params)

    respond_to do |format|
      if @variable_field_category.save
        format.html { redirect_to @variable_field_category, notice: 'Variable field category was successfully created.' }
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
    respond_to do |format|
      if @variable_field_category.update(variable_field_category_params)
        format.html { redirect_to @variable_field_category, notice: 'Variable field category was successfully updated.' }
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
    @variable_field_category.destroy
    respond_to do |format|
      format.html { redirect_to variable_field_categories_url }
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
      params.require(:variable_field_category).permit(:name, :rgb, :description, :user_id)
    end
end
