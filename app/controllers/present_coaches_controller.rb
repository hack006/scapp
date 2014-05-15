class PresentCoachesController < ApplicationController
  before_action :set_present_coach, only: [:show, :edit, :update, :destroy]
  before_action :set_training_lesson_realization

  authorize_resource

  # GET /present_coaches
  # GET /present_coaches.json
  def index
    @present_coaches = @training_lesson_realization.present_coaches
  end

  # GET /present_coaches/1
  # GET /present_coaches/1.json
  def show
  end

  # GET /present_coaches/new
  def new
    @present_coach = PresentCoach.new
    @coaches = Role.where(name: :coach).first.users

   get_obligation_guesses
  end

  # GET /present_coaches/1/edit
  def edit
    @coaches = Role.where(name: :coach).first.users
    @present_coach.user_email = @present_coach.user.email
  end

  # POST /present_coaches
  # POST /present_coaches.json
  def create
    @present_coach = PresentCoach.new(present_coach_params)
    @present_coach.training_lesson_realization = @training_lesson_realization
    @present_coach.user = User.where(email: params[:present_coach][:user_email]).first
    get_obligation_guesses

    respond_to do |format|
      if @present_coach.save
        format.html { redirect_to @training_lesson_realization, notice: t('present_coach.controller.successfully_added') }
        format.json { render action: 'show', status: :created, location: @present_coach }
      else
        format.html { render action: 'new' }
        format.json { render json: @present_coach.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /present_coaches/1
  # PATCH/PUT /present_coaches/1.json
  def update
    respond_to do |format|
      if @present_coach.update(present_coach_params)
        format.html { redirect_to @training_lesson_realization, notice: t('present_coach.controller.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @present_coach.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /present_coaches/1
  # DELETE /present_coaches/1.json
  def destroy
    @present_coach.destroy
    respond_to do |format|
      format.html { redirect_to @training_lesson_realization, notice: t('present_coach.controller.successfully_removed')}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_present_coach
      @present_coach = PresentCoach.find(params[:id])
    end

    def set_training_lesson_realization
      if params[:training_lesson_realization_id]
        @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:training_lesson_realization_id])
      elsif params[:regular_training_lesson_realization_id]
        @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:regular_training_lesson_realization_id])
      elsif params[:individual_regular_training_lesson_realization_id]
        @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:individual_training_lesson_realization_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def present_coach_params
      params.require(:present_coach).permit(:salary_without_tax, :vat_id, :currency_id, :supplementation, :user_email)
    end

    def get_obligation_guesses
      # get guesses for regular training lesson
      if @training_lesson_realization && @training_lesson_realization.is_regular?
        @regular_training_obligations = Hash.new

        @training_lesson_realization.training_lesson.regular_training.coach_obligations.each do |o|
          @regular_training_obligations[o.user.slug] = { vat_id: o.vat_id, currency_id: o.currency_id, user_email: o.user.email,
                                                         name: o.user.name, hourly_wage_without_tax: o.hourly_wage_without_vat,
                                                         wage_without_tax: (o.hourly_wage_without_vat * @training_lesson_realization.training_lesson.training_length(:hour,2)),
                                                         currency_symbol: o.currency.symbol, vat_name: o.vat.name }
        end
      end
    end
end
