class VariableFieldsController < ApplicationController
  before_action :set_variable_field, only: [:show, :edit, :update, :destroy]

  # GET /variable_fields
  # GET /variable_fields.json
  def index
    @variable_fields = VariableField.all
  end

  # GET /variable_fields/1
  # GET /variable_fields/1.json
  def show
  end

  # GET /variable_fields/new
  def new
    @variable_field = VariableField.new
  end

  # GET /variable_fields/1/edit
  def edit
  end

  # POST /variable_fields
  # POST /variable_fields.json
  def create
    @variable_field = VariableField.new(variable_field_params)

    respond_to do |format|
      if @variable_field.save
        format.html { redirect_to @variable_field, notice: 'Variable field was successfully created.' }
        format.json { render action: 'show', status: :created, location: @variable_field }
      else
        format.html { render action: 'new' }
        format.json { render json: @variable_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variable_fields/1
  # PATCH/PUT /variable_fields/1.json
  def update
    respond_to do |format|
      if @variable_field.update(variable_field_params)
        format.html { redirect_to @variable_field, notice: 'Variable field was successfully updated.' }
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
    @variable_field.destroy
    respond_to do |format|
      format.html { redirect_to variable_fields_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable_field
      @variable_field = VariableField.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variable_field_params
      params.require(:variable_field).permit(:name, :description, :unit, :higher_is_better, :is_numeric, :user_id, :variable_field_category_id)
    end
end
