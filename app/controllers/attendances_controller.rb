class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]
  before_action :set_training_lesson_realization, except: [:index, :player_attendance]
  before_action :set_regular_training, only: [:index, :player_attendance]

  load_and_authorize_resource except: [:new, :create]

  # GET /attendances
  # GET /attendances.json
  def index
    # get currency
    currencies = @regular_training.training_lessons.map{ |l| l.currency }.uniq{ |c| c.id}
    if currencies.count == 1
      @currency = currencies[0]
    else
      @currency = nil
    end

    @attendance_graph_data = { signed: {}, present: {}, excused: {}, unexcused: {} }
    @attendance_graph_data_arr = { income: [], costs: {} }

    @regular_training_lessons = @regular_training.training_lessons
    @closed_scheduled_lessons = RegularTrainingLessonRealization.
        joins(:attendances).
        where(training_lesson_id: @regular_training_lessons, status: :done).
        order(date: :desc).uniq


    # if date range filter active, then use it
    begin
      @from_date = params[:from_date].blank? ? nil : Date.strptime(params[:from_date], '%d/%m/%Y')
      @until_date = params[:until_date].blank? ? nil : Date.strptime(params[:until_date], '%d/%m/%Y')
    rescue
      flash[:alert] = t('attendance.controller.bad_date_format')
    end

    @closed_scheduled_lessons = @closed_scheduled_lessons.where('date >= ?', @from_date) if @from_date
    @closed_scheduled_lessons = @closed_scheduled_lessons.where('date <= ?', @until_date) if @until_date

    # paginated version to secure good view results
    @closed_scheduled_lessons_paginated = @closed_scheduled_lessons.page(params[:page]).per(10)

    # populate graph stat
    @closed_scheduled_lessons.each do |l|
      # attendance
      @attendance_graph_data[:signed][l.slug.to_sym] = {y: 0, x: DateTime.from_date_and_time(l.date, l.from).to_i * 1000, start_at: DateTime.from_date_and_time(l.date, l.from)}
      @attendance_graph_data[:present][l.slug.to_sym] = {y: 0, x: DateTime.from_date_and_time(l.date, l.from).to_i * 1000, start_at: DateTime.from_date_and_time(l.date, l.from)}
      @attendance_graph_data[:excused][l.slug.to_sym] = {y: 0, x: DateTime.from_date_and_time(l.date, l.from).to_i * 1000, start_at: DateTime.from_date_and_time(l.date, l.from)}
      @attendance_graph_data[:unexcused][l.slug.to_sym] = {y: 0, x: DateTime.from_date_and_time(l.date, l.from).to_i * 1000, start_at: DateTime.from_date_and_time(l.date, l.from)}

      # finance
      @attendance_graph_data_arr[:income] <<  {y: l.income, x: DateTime.from_date_and_time(l.date, l.from).to_i * 1000, start_at: DateTime.from_date_and_time(l.date, l.from), currency: l.currency.code}
      l.costs.each do |currency, value|
        @attendance_graph_data_arr[:costs][currency] = [] if @attendance_graph_data_arr[:costs][currency].nil?
        @attendance_graph_data_arr[:costs][currency] << {y: l.costs[currency], x: DateTime.from_date_and_time(l.date, l.from).to_i * 1000, start_at: DateTime.from_date_and_time(l.date, l.from), currency: currency}
      end
    end

    # holds whole map
    @user_attendances = Hash.new

    Attendance.
        where(training_lesson_realization_id: @closed_scheduled_lessons).
        joins(:user).
        select('user_id').distinct.each do |attendance|
      @user_attendances[attendance.user.slug.to_sym] = { user: attendance.user }
    end

    @closed_scheduled_lessons.each do |l|
      l.attendances.each do |a|
        @user_attendances[a.user.slug.to_sym][l.slug] = a

        if [:signed, :present, :excused, :unexcused].include? a.participation.to_sym
          @attendance_graph_data[a.participation][l.slug.to_sym][:y] += 1
        end
      end
    end

    # Map to usable arrays for JS highchart plotting library
    [:signed, :present, :excused, :unexcused].each do |state|
      @attendance_graph_data_arr[state] = @attendance_graph_data[state].map{ |key, val| val}
      @attendance_graph_data_arr[state].sort_by!{|f| f[:x]}
    end

    # Sort finance graphs
    @attendance_graph_data_arr[:income].sort_by!{ |f| f[:x] }
    @attendance_graph_data_arr[:costs].each do |currency, val|
      @attendance_graph_data_arr[:costs][currency].sort_by!{ |f| f[:x] }
    end
  end

  # GET /attendances/1
  # GET /attendances/1.json
  def show
  end

  # GET /attendances/new
  def new
    authorize! :create, Attendance

    @attendance = Attendance.new
    @attendance.price_without_tax = 0 # fill default value for individual training
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances
  # POST /attendances.json
  def create
    authorize! :create, Attendance

    @attendance = Attendance.new(attendance_params)
    @attendance.user = User.where(email: @attendance.user_email).first
    @attendance.training_lesson_realization = @training_lesson_realization
    @attendance.participation = :signed
    @attendance.price_without_tax = 0 if @training_lesson_realization.is_regular?

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to @training_lesson_realization, notice: t('attendance.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @attendance }
      else
        format.html { render action: 'new' }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendances/1
  # PATCH/PUT /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to @training_lesson_realization, notice: t('attendance.controller.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.json
  def destroy
    @attendance.destroy
    respond_to do |format|
      format.html { redirect_to @training_lesson_realization, notice: t('attendance.controller.successfully_deleted') }
      format.json { head :no_content }
    end
  end

  # GET /scheduled_lessons/public-9-4-2014-16-00-17-30/attendances/fill
  def fill
    @attendances = @training_lesson_realization.attendances
  end

  # POST /scheduled_lessons/public-9-4-2014-16-00-17-30/attendances/fill
  def save_fill

    errors = []
    params[:attendances].each do |attendance_id, a|
      # we only can manipulate with attendance for current scheduled lesson!
      begin
        attendance = @training_lesson_realization.attendances.find(attendance_id)

        attendance.participation = a[:status].to_sym if !attendance.nil? && Attendance::PARTICIPATION_STATES.include?(a[:status].to_sym)
        attendance.save!
      rescue Exception => e
        errors << "'User[#{(attendance && attendance.user) ? attendance.user.name : '?'}] - #{e.message}'"
      end
    end

    if errors.empty?
      redirect_to calc_payment_training_lesson_realization_attendances_path(@training_lesson_realization),
                  notice: t('attendance.fill.attendance_successfully_filled')
    else
      redirect_to @training_lesson_realization, alert: t('attendance.fill.attendance_fill_failed', errors: errors.join(", "))
    end
  end

  def calc_payment
    @attendances = @training_lesson_realization.calculated_attendances
    @player_payment = @training_lesson_realization.calculate_player_price_without_vat
    @player_payment_with_vat = @player_payment[:player_price_without_vat] * (1 + @training_lesson_realization.training_vat.percentage_value / 100 )
    @total_lesson_costs = @player_payment[:total_costs]

  end

  def save_calc_payment
    # we only can manipulate with attendances of current lesson
    params[:attendance_payment].each do |id, value|
      begin
       attendance = @training_lesson_realization.attendances.find(id)
      rescue Exception => e
        redirect_to @training_lesson_realization, error: t('attendance.calc_payment.can_not_manipulate_with_foreign_attendance')
        return
      end

      begin
        attendance.update_attribute(:price_without_tax, value)
      rescue Exception => e
        redirect_to calc_payment_training_lesson_realization_attendances_path(@training_lesson_realization),
                    error: t('attendance.calc_payment.updating_price_failed')
        return
      end
    end

    # invited, signed and excused players do not pay
    @training_lesson_realization.attendances.where(participation: [:invited, :signed, :excused]).each do |a|
      a.update_attribute(:price_without_tax, 0)
    end

    redirect_to @training_lesson_realization, notice: t('attendance.calc_payment.new_prices_succuessfully_saved')
  end

  # Shows player attendance and some basic statistics
  #
  # GET /regular_trainings/adults-group-a/attendances/player/player123
  def player_attendance
    # if date range filter active, then use it
    begin
      @from_date = params[:from_date].blank? ? nil : Date.strptime(params[:from_date], '%d/%m/%Y')
      @until_date = params[:until_date].blank? ? nil : Date.strptime(params[:until_date], '%d/%m/%Y')
    rescue
      flash[:alert] = t('attendance.controller.bad_date_format')
    end

    @player = User.friendly.find(params[:user_id])
    @regular_training_lessons = @regular_training.training_lessons
    @attendances = Attendance.joins(:training_lesson_realization).
        includes(:training_lesson_realization).
        where('training_lesson_realizations.training_lesson_id' => @regular_training_lessons, user: @player,
              'training_lesson_realizations.status' => :done).
        order('training_lesson_realizations.date DESC')

    @attendances = @attendances.where('training_lesson_realizations.date >= ?', @from_date) if @from_date
    @attendances = @attendances.where('training_lesson_realizations.date <= ?', @until_date) if @until_date

    # get paged variant
    @paged_attendances = @attendances.page(params[:page])

    # calc sum
    @sum_price = {}
    @paged_attendances.each do |a|
      currency = a.training_lesson_realization.currency.code.to_sym

      # If not used then set up, otherwise add prices to SUM
      if @sum_price[currency].nil?
        @sum_price[currency] = { with_vat: { currency_symbol: a.training_lesson_realization.currency.symbol, sum: a.price_with_tax },
                                 without_vat: { currency_symbol: a.training_lesson_realization.currency.symbol, sum: a.price_without_tax } }
      else
        @sum_price[currency][:with_vat][:sum] += a.price_with_tax
        @sum_price[currency][:without_vat][:sum] += a.price_without_tax
      end

    end

    # STATISTICS CALCULATIONS

    # 1) participation percentage
    @participation = Hash.new
    @participation[:present] = { count: 0, percentage: 0 }
    @participation[:excused] = { count: 0, percentage: 0 }
    @participation[:unexcused] = { count: 0, percentage: 0 }
    @participation_count = 0

    @attendances.each do |a|
      if [:present, :excused, :unexcused].include? a.participation
        @participation[a.participation][:count] += 1
        @participation_count += 1
      end
    end

    # count percentage
    @participation.each do |key, p|
      p[:percentage] = p[:count] / @participation_count.to_f * 100
    end

    #2) percentage of visits of possible lessons
    realized_lessons = RegularTrainingLessonRealization.
        where(training_lesson_id: @regular_training_lessons, status: [:done])
    unless realized_lessons.count == 0
      # realized lessons where user has attendance entry
      user_present_realized_lessons = RegularTrainingLessonRealization.
          where(training_lesson_id: @regular_training_lessons, status: [:done]).
          joins(:attendances).
          where('attendances.user_id = ? AND attendances.participation = "present"', @player.id)
      @participation_percentage = user_present_realized_lessons.count / realized_lessons.count.to_f * 100
    else
      @participation_percentage = 0
    end

    render 'regular_trainings/attendances/user/player_attendance'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    def set_training_lesson_realization
        @training_lesson_realization = TrainingLessonRealization.friendly.find(params[:training_lesson_realization_id])
    end

    def set_regular_training
      @regular_training = RegularTraining.friendly.find(params[:regular_training_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendance_params
      params.require(:attendance).permit(:participation, :price_without_tax, :user_email, :note)
    end
end
