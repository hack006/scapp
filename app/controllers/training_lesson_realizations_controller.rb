class TrainingLessonRealizationsController < ApplicationController
  before_action :set_training_lesson_realization, only: [:show, :edit, :update, :destroy, :close, :cancel, :reopen, :sign_in, :excuse]
  load_and_authorize_resource except: [:index]
  TRAINING_LESSONS_PER_PAGE = 25

  # GET /training_lesson_realizations
  # GET /training_lesson_realizations.json
  def index
    @regular_training = RegularTraining.friendly.find(params[:regular_training_id])

    authorize! :list_training_lesson_realizations, @regular_training

    regular_training_lessons_ids = @regular_training.training_lessons.map{ |l| l.id }

    # if page not explicitly specified select page with closest scheduled lesson
    # referer solve problem with first page where params[:page] is not set
    if request.referer.nil? || request.referer != regular_training_training_lesson_realizations_url(@regular_training)
      count = RegularTrainingLessonRealization.
          where('training_lesson_id IN(:ids) AND date <= :date ', ids: regular_training_lessons_ids, date: Date.current).
          count
      params[:page] = count.div(TRAINING_LESSONS_PER_PAGE) + 1 unless count == 0
    end

    @training_lesson_realizations = RegularTrainingLessonRealization.
        where(training_lesson_id: regular_training_lessons_ids).
        order(date: :asc).
        page(params[:page]).
        per(TRAINING_LESSONS_PER_PAGE)
  end

  # GET /training_lesson_realizations/1
  # GET /training_lesson_realizations/1.json
  def show
  end

  # GET /training_lesson_realizations/new
  def new
    @training_lesson_realization = IndividualTrainingLessonRealization.new
    @training_lesson_realization.status = :scheduled # fill default value for form - this is disabled field

    # Guess admin as owner
    @training_lesson_realization.user = current_user if current_user.is_admin?
  end

  # GET /training_lesson_realizations/1/edit
  def edit

  end

  # POST /training_lesson_realizations
  # POST /training_lesson_realizations.json
  def create
    @training_lesson_realization = IndividualTrainingLessonRealization.new(individual_training_lesson_realization_params)

    # Fill in default values
    @training_lesson_realization.user = current_user
    @training_lesson_realization.status = :scheduled

    if !@training_lesson_realization.date.blank? && !@training_lesson_realization.from.blank? && params[:individual_training_lesson_realization][:sign_in_time].blank?
      @training_lesson_realization.sign_in_time = DateTime.from_date_and_time(@training_lesson_realization.date, @training_lesson_realization.from)
    end

    if !@training_lesson_realization.date.blank? && !@training_lesson_realization.from.blank? && params[:individual_training_lesson_realization][:excuse_time].blank?
      @training_lesson_realization.excuse_time = DateTime.from_date_and_time(@training_lesson_realization.date, @training_lesson_realization.from)
    end

    # only admin can manipulate with lesson owner
    if current_user.is_admin?
      @training_lesson_realization.user = User.friendly.find(params[:individual_training_lesson_realization][:user_id])
    end

    respond_to do |format|
      if @training_lesson_realization.save
        format.html { redirect_to @training_lesson_realization, notice: t('training_lesson.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @training_lesson_realization }
      else
        format.html { render action: 'new' }
        format.json { render json: @training_lesson_realization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /training_lesson_realizations/1
  # PATCH/PUT /training_lesson_realizations/1.json
  def update
    # Todo secure training_lesson_id change! - secured by ability class??
    respond_to do |format|
      if @training_lesson_realization.update((@training_lesson_realization.is_regular?) ? regular_training_lesson_realization_params : individual_training_lesson_realization_params )
        format.html { redirect_to @training_lesson_realization, notice: t('training_realization.controller.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @training_lesson_realization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /training_lesson_realizations/1
  # DELETE /training_lesson_realizations/1.json
  def destroy
    @training_lesson_realization.destroy
    respond_to do |format|
      format.html { redirect_to training_lesson_realizations_url, t('training_realization.controller.successfully_deleted') }
      format.json { head :no_content }
    end
  end

  # Close training with status :DONE and deny further modifications
  #
  # GET /scheduled_lessons/public-9-4-2014-16-00-17-30/close
  def close
    authorize! :close, @training_lesson_realization

    # TODO fill in errors if some exist
    # TODO calculate price for players!!
    errors = ''
    # check that all attendance statuses are only [:present, :excused, :unexcused]
    if @training_lesson_realization.can_close?
      @training_lesson_realization.status = :done
      @training_lesson_realization.save

      redirect_to @training_lesson_realization, notice: t('training_realization.controller.successfully_closed')
    else
      redirect_to @training_lesson_realization, notice: t('training_realization.controller.closing_failed', errors: errors)
    end
  end

  # Close training with status :CANCELED and deny further modifications
  #
  # GET /scheduled_lessons/public-9-4-2014-16-00-17-30/cancel
  def cancel
    authorize! :cancel, @training_lesson_realization

    # change satus
    @training_lesson_realization.status = :canceled
    @training_lesson_realization.save

    # zero all attendances and change state to invited for the case of reopen
    @training_lesson_realization.attendances.each do |a|
      a.price_without_tax = 0
      a.participation = :invited
      a.save
    end

    redirect_to @training_lesson_realization, notice: t('training_realization.controller.succesfully_canceled')
  end

  # Reopen training lesson and allow modifications if its possible
  #
  #   REQUIREMENTS:
  #   * no payment is connected to training lesson attendance!
  #   * other??
  #
  # GET /scheduled_lessons/public-9-4-2014-16-00-17-30/reopen
  def reopen
    authorize! :reopen, @training_lesson_realization

    # check that all attendance statuses are only [:present, :excused, :unexcused]
    if @training_lesson_realization.closed?
      # TODO check REQUIREMENTS - required at state when calculation and facturation is ready
      @training_lesson_realization.status = :scheduled
      @training_lesson_realization.save

      redirect_to @training_lesson_realization, notice: t('training_realization.controller.successfully_reopened')
    else
      redirect_to @training_lesson_realization, alert: t('training_realization.controller.can_not_reopen_cause_not_closed')
    end
  end

  # If possible sign in to scheduled lesson
  #
  # REQUIREMENTS:
  #
  #   * excuse is made before register time limit
  #   * current user is not already signed in (attendance entry exist)
  #   * lesson player limit is not reached
  #
  # GET /scheduled_lessons/public-9-4-2014-16-00-17-30/sign_in
  def sign_in
    authorize! :sign_in, @training_lesson_realization

    # find attendance entry, if user specified then we sign in another user
    if params[:user_id]
      player = User.friendly.find(params[:user_id])
      attendance = @training_lesson_realization.attendances.where(user: player).first

      unless attendance
        redirect_to @training_lesson_realization, notice: t('training_realization.controller.player_not_registered_as_training_player')
        return
      end
    else
      attendance = @training_lesson_realization.attendances.where(user: current_user).first
    end

    if attendance && attendance.participation != :signed
      unless attendance.can_sign_in?
        redirect_to @training_lesson_realization, alert: t('training_realization.controller.sign_in_not_possible')
        return
      end
      attendance.update_attribute(:participation, :signed)

      redirect_to @training_lesson_realization, notice: t('training_realization.controller.sign_in_success')
    else
      redirect_to @training_lesson_realization, notice: t('training_realization.controller.signed_in_already_signed')
    end
  end

  # If possible excuse currently logged in player from scheduled lesson
  #
  # REQUIREMENTS:
  #
  #   * excuse is made before excuse time limit
  #   * current user is already signed in lesson (attendance entry exist)
  #
  # GET /scheduled_lessons/public-9-4-2014-16-00-17-30/excuse
  def excuse
    authorize! :excuse, @training_lesson_realization

    # find attendance entry
    attendance = @training_lesson_realization.attendances.where(user: current_user).first
    if attendance
      unless attendance.can_excuse?
        redirect_to @training_lesson_realization, alert: t('training_realization.controller.excuse_not_possible')
        return
      end

      attendance.update_attribute(:participation, :excused)

      redirect_to @training_lesson_realization, notice: t('training_realization.controller.excuse_success')
    else
      redirect_to @training_lesson_realization, notice: t('training_realization.controller.excuse_you_are_not_signed_player')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_training_lesson_realization
      @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def training_lesson_realization_params
      params.require(:training_lesson_realization).permit(:date, :from, :until, :player_price_without_tax, :group_price_without_tax, :rental_price_without_tax, :calculation, :status, :note, :training_vat_id, :rental_vat_id, :currency_id, :training_lesson_id, :user_id, :sign_in_time, :excuse_time)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def individual_training_lesson_realization_params
      params.require(:individual_training_lesson_realization).permit(:date, :from, :until, :player_price_without_tax, :group_price_without_tax, :rental_price_without_tax, :calculation, :status, :note, :training_vat_id, :rental_vat_id, :currency_id, :is_open, :player_count_limit, :sign_in_time, :excuse_time)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def regular_training_lesson_realization_params
      params.require(:regular_training_lesson_realization).permit(:player_price_without_tax, :group_price_without_tax, :rental_price_without_tax, :calculation, :note, :training_vat_id, :rental_vat_id, :training_lesson_id, :sign_in_time, :excuse_time)
    end

end
