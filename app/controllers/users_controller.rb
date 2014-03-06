class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show
    @user = User.friendly.find(params[:id])

    # TODO:
    #  - show user variables
    #  - show training info (stats, timetable)
    #  - show couches (public?)
    #  - show groups user is in? (user, admin, coach?)
    #  - show user relations user has? (user, admin, coach?)
  end

  # GET /users/new
  def new
    @user = User.new

    render 'users/new'
  end

  # Edit user
  #
  # Only :admin can do this
  #
  # GET /users/1/edit
  # @params [String] :id friendly_id slug identifier
  def edit
    @user = User.friendly.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: t('user.controller.user_create_success') }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'

    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'

    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end