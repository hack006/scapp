class RegularTrainingsController < ApplicationController
  before_action :set_regular_training, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource except: [:create]

  # GET /regular_trainings
  # GET /regular_trainings.json
  def index
    if is_admin?
      @regular_trainings = RegularTraining.all.page(params[:page])
      @groups = UserGroup.all
    elsif is_coach?
      @regular_trainings = RegularTraining.where('public = true OR user_id = ?', current_user.id).page(params[:page])
      @groups = UserGroup.registered_visible(current_user)
    else
      @regular_trainings = RegularTraining.where('public = true').page(params[:page])
    end
  end

  # GET /regular_trainings/1
  # GET /regular_trainings/1.json
  def show
    # Get training lessons
    @training_lessons = { mon: [], tue: [], wed: [], thu: [], fri: [], sat: [], sun: [] }

    @regular_training.training_lessons.map do |l|
      position_from_top = (l.from.seconds_since_midnight / 3600 * 40).round
      height = ((l.until - l.from) / 1.hour * 40).round

      @training_lessons[l.day] << { id: l.id, from: l.from.short, until: l.until.short, height: height,
                                    position_from_top: position_from_top, odd: l.odd_week, even: l.even_week }
    end
  end

  # GET /regular_trainings/new
  def new
    @regular_training = RegularTraining.new

    load_usable_groups
    @groups_select = get_groups_for_select
  end

  # GET /regular_trainings/1/edit
  def edit
    load_usable_groups
    @groups_select = get_groups_for_select
  end

  # POST /regular_trainings
  # POST /regular_trainings.json
  def create
    authorize! :create, RegularTraining

    @regular_training = RegularTraining.new(regular_training_params)
    @regular_training.user = current_user

    # test if user can assign this group
    load_usable_groups
    begin
      group = UserGroup.find(params[:regular_training][:user_group])
    rescue
      group = nil
    end

    if group.nil? || @groups.include?(group)
      @regular_training.user_group = group
    else
      redirect_to new_regular_training_path, alert: t('regular_trainings.controller.invalid_group_choosen')
      return
    end

    respond_to do |format|
      if @regular_training.save
        format.html { redirect_to @regular_training, notice: t('regular_trainings.controller.successfully_created') }
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
    # test if user can assign this group
    load_usable_groups
    group = UserGroup.find(params[:regular_training][:user_group])
    if @groups.include?(group)
      @regular_training.user_group = group
    else
      redirect_to new_regular_training_path, alert: t('regular_trainings.controller.invalid_group_choosen')
      return
    end

    respond_to do |format|
      if @regular_training.update(regular_training_params)
        format.html { redirect_to @regular_training, notice: t('regular_trainings.controller.successfully_updated') }
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
      format.html { redirect_to regular_trainings_url, notice: t('regular_trainings.controller.successfully_removed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_regular_training
      @regular_training = RegularTraining.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def regular_training_params
      params.require(:regular_training).permit(:name, :description, :public, :user_id)
    end

    # Get groups which current user can use for assignment
    def load_usable_groups
      if is_admin?
        @groups = UserGroup.all
      elsif is_coach?
        @groups = UserGroup.global_or_owned_by(current_user)
      else
        @groups = UserGroup.global
      end
    end

    def get_groups_for_select
      @groups.map do|g|
        if g.is_global?
          [ "#{g.name} [GLOBAL]", "#{g.id}" ]
        elsif g.owner == current_user
          [ "#{g.name} [OWNED]", "#{g.id}" ]
        else
          [ "#{g.name}", "#{g.id}" ]
        end
      end
    end
end
