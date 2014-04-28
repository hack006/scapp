class CoachObligationsController < ApplicationController
  before_action :set_coach_obligation, only: [:show, :edit, :update, :destroy]
  before_action :set_regular_training

  load_and_authorize_resource except: [:create]

  # GET /coach_obligations.json
  def index
    @coach_obligations = @regular_training.coach_obligations.page(params[:page])
  end

  # GET /coach_obligations/1
  # GET /coach_obligations/1.json
  def show
  end

  # GET /coach_obligations/new
  def new
    @coach_obligation = CoachObligation.new
    @coach_obligation.regular_training = @regular_training

    authorize! :create, @coach_obligation
  end

  # GET /coach_obligations/1/edit
  def edit
    @coach_obligation.coach_email = @coach_obligation.user.email
  end

  # POST /coach_obligations
  # POST /coach_obligations.json
  def create
    @coach_obligation = CoachObligation.new(coach_obligation_params)
    @coach_obligation.coach_email = params[:coach_obligation][:coach_email]
    user = User.where(email: @coach_obligation.coach_email).first

    if user
      @coach_obligation.regular_training = @regular_training
      @coach_obligation.user = user

      authorize! :create, @coach_obligation
    end

    respond_to do |format|
      if @coach_obligation.save
        format.html { redirect_to @regular_training, notice: t('coach_obligation.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @coach_obligation }
      else
        format.html { render action: 'new' }
        format.json { render json: @coach_obligation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coach_obligations/1
  # PATCH/PUT /coach_obligations/1.json
  def update
    @coach_obligation.coach_email = @coach_obligation.user.email

    respond_to do |format|
      if @coach_obligation.update(coach_obligation_params.except(:user_id, :coach_email))
        format.html { redirect_to @regular_training, notice: t('coach_obligation.controller.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @coach_obligation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coach_obligations/1
  # DELETE /coach_obligations/1.json
  def destroy
    @coach_obligation.destroy
    respond_to do |format|
      format.html { redirect_to @regular_training, notice: t('coach_obligation.controller.successfully_removed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coach_obligation
      @coach_obligation = CoachObligation.find(params[:id])
    end

    # Load regular training based on provided regular_training_id param
    def set_regular_training
      begin
        @regular_training = RegularTraining.friendly.find(params[:regular_training_id])
      rescue Exception => e
        redirect_to regular_trainings_path, alert: t('training_lesson.controller.regular_training_not_found')
        return
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coach_obligation_params
      params.require(:coach_obligation).permit(:hourly_wage_without_vat, :role, :vat_id, :user_id, :regular_training_id, :currency_id)
    end
end
