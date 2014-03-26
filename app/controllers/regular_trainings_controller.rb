class RegularTrainingsController < ApplicationController
  before_action :set_regular_training, only: [:show, :edit, :update, :destroy]

  # GET /regular_trainings
  # GET /regular_trainings.json
  def index
    @regular_trainings = RegularTraining.all
  end

  # GET /regular_trainings/1
  # GET /regular_trainings/1.json
  def show
  end

  # GET /regular_trainings/new
  def new
    @regular_training = RegularTraining.new
  end

  # GET /regular_trainings/1/edit
  def edit
  end

  # POST /regular_trainings
  # POST /regular_trainings.json
  def create
    @regular_training = RegularTraining.new(regular_training_params)

    respond_to do |format|
      if @regular_training.save
        format.html { redirect_to @regular_training, notice: 'Regular training was successfully created.' }
        format.json { render action: 'show', status: :created, location: @regular_training }
      else
        format.html { render action: 'new' }
        format.json { render json: @regular_training.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /regular_trainings/1
  # PATCH/PUT /regular_trainings/1.json
  def update
    respond_to do |format|
      if @regular_training.update(regular_training_params)
        format.html { redirect_to @regular_training, notice: 'Regular training was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @regular_training.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /regular_trainings/1
  # DELETE /regular_trainings/1.json
  def destroy
    @regular_training.destroy
    respond_to do |format|
      format.html { redirect_to regular_trainings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_regular_training
      @regular_training = RegularTraining.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def regular_training_params
      params.require(:regular_training).permit(:name, :description, :public, :user_id)
    end
end
