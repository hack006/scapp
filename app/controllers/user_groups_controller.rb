class UserGroupsController < ApplicationController
  before_action :set_user_group, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource except: [:user_in, :create]

  # GET /user_groups
  # GET /user_groups.json
  def index
    # admin see all
    if is_admin?
      @user_groups = UserGroup.all.page(params[:page])
    # others see
    #   - public groups and groups visible by registered users
    #   - own groups
    #   - groups visible to their members
    elsif is_coach? || is_player? || is_watcher?
      @user_groups = UserGroup.registered_visible(current_user).page(params[:page])
    else
      redirect_to root_path, alert: t('user_groups.controller.not_have_required_role')
    end
  end

  # GET /user_groups/1
  # GET /user_groups/1.json
  def show
  end

  # GET /user_groups/new
  def new
    @user_group = UserGroup.new
  end

  # GET /user_groups/1/edit
  def edit
  end

  # POST /user_groups
  # POST /user_groups.json
  def create
    # TODO implement policy of duplicit names
    @user_group = UserGroup.new(user_group_params)
    # set owner
    @user_group.owner = current_user
    # only admin can create global groups
    if is_admin?
      @user_group.is_global = params[:user_group][:is_global]
    end

    authorize! :create, UserGroup

    respond_to do |format|
      if @user_group.save
        format.html { redirect_to user_groups_path, notice: t('user_groups.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @user_group }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_groups/1
  # PATCH/PUT /user_groups/1.json
  def update
    # only admin can create global groups
    if is_admin?
      @user_group.is_global = params[:user_group][:is_global]
    end

    respond_to do |format|
      if @user_group.update(user_group_params)
        format.html { redirect_to @user_group, notice: 'User group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_groups/1
  # DELETE /user_groups/1.json
  def destroy
    @user_group.destroy
    respond_to do |format|
      format.html { redirect_to user_groups_path, notice: t('user_groups.controller.successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  # List groups user is listed in
  #
  # Only owner, :coach, :admin can see this
  #
  # @controller_action
  def user_in
    authorize! :user_in, UserGroup

    @user = User.friendly.find(params[:user_id])
    if is_admin?
      @user_groups = @user.user_groups.page(params[:page])
    else
      @user_groups = @user.user_groups.where('visibility != "owner" OR user_groups.user_id = ?', current_user.id).page(params[:page])
    end

    render 'users/user_groups/in'
  end

  # Add user to group if not already present
  #
  # @param [Integer] id user group id
  def add_user
    @user_group = UserGroup.find(params[:id])
    @user = User.where(email: params[:user_group_user][:email]).first

    unless @user
      redirect_to user_group_path(@user_group), alert: 'User was not found.'
      return
    end

    @user_group.users << @user
    if @user_group.save
      redirect_to user_group_path(@user_group), notice: 'User successfully added.'
    else
      redirect_to user_group_path(@user_group), alert: 'Unexpected error appeared while processing your request'
    end
  end

  # Remove user from group if already present
  #
  # @param [Integer] id user group id
  # @param [Integer] user_id user to remove
  def remove_user
    @user_group = UserGroup.find(params[:id])
    @user = User.friendly.find(params[:user_id])

    unless @user
      redirect_to user_group_path(@user_group), alert: 'User was not found.'
      return
    end

    if @user.user_groups.delete(@user_group)
      redirect_to user_group_path(@user_group), notice: 'User successfully removed.'
    else
      redirect_to user_group_path(@user_group), alert: 'Unexpected error appeared while processing your request'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_group
      @user_group = UserGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_group_params
      params.require(:user_group).permit(:name, :description, :long_description, :visibility)
    end
end
