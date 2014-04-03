# TODO check regular training access in ability
class TrainingLessonsController < ApplicationController
  before_action :set_training_lesson, only: [:show, :edit, :update, :destroy]
  before_action :set_regular_training

  load_and_authorize_resource except: [:new, :create]

  # GET /training_lessons
  # GET /training_lessons.json
  def index
    @training_lessons = @regular_training.training_lessons.order(day: :asc).page(params[:page])
  end

  # GET /training_lessons/1
  # GET /training_lessons/1.json
  def show
  end

  # GET /training_lessons/new
  def new
    @training_lesson = TrainingLesson.new
    @training_lesson.regular_training = @regular_training

    authorize! :new, @training_lesson


    # Some VAT has to exist in the system
    redirect_to is_admin? ? new_vat_path : root_path, alert: t('training_lesson.controller.vat_must_be_added_firstly') if Vat.count == 0
    # Some currency has to exist in the system
    redirect_to is_admin? ? new_currency_path : root_path, alert: t('training_lesson.controller.currency_must_be_added_firstly') if Currency.count == 0

  end

  # GET /training_lessons/1/edit
  def edit
  end

  # POST /training_lessons
  # POST /training_lessons.json
  def create
    @training_lesson = TrainingLesson.new(training_lesson_params)
    @training_lesson.regular_training = @regular_training

    authorize! :create, @training_lesson

    # time needn't overlap existing one!!
    overlapping = !@regular_training.training_lessons.
        where('((`from` < :from AND until > :from) OR (`from` < :until AND until > :until)) AND day = :day',
              from: @training_lesson.from.short, until: @training_lesson.until.short, day: @training_lesson.day).empty?

    respond_to do |format|
      if !overlapping && @training_lesson.save
        format.html { redirect_to [@regular_training, @training_lesson], notice: t('training_lesson.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @training_lesson }
      else
        flash[:alert] = t('training_lesson.controller.overlapping_already_existing_lesson') if overlapping

        format.html { render action: 'new' }
        format.json { render json: @training_lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /training_lessons/1
  # PATCH/PUT /training_lessons/1.json
  def update
    respond_to do |format|
      if @training_lesson.update(training_lesson_params)
        format.html { redirect_to [@regular_training, @training_lesson], notice: t('training_lesson.controller.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @training_lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /training_lessons/1
  # DELETE /training_lessons/1.json
  def destroy
    @training_lesson.destroy
    respond_to do |format|
      format.html { redirect_to regular_training_training_lessons_path(@regular_training), notice: t('training_lesson.controller.successfully_removed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_training_lesson
      @training_lesson = TrainingLesson.find(params[:id])
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
    def training_lesson_params
      params.require(:training_lesson).permit(:description, :day, :from, :until, :odd_week, :even_week, :calculation,
                                              :from_date, :until_date, :player_price_without_tax, :group_price_without_tax,
                                              :rental_price_without_tax, :training_vat_id, :rental_vat_id, :currency_id)
    end
end
