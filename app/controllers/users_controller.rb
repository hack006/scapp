class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  authorize_resource except: [:update, :email_hinter]

  def index
    @users ||= User.new

    # TODO optimize select
    if is_admin?
      @users = User.all.page(params[:page])
    elsif is_coach? || is_player?
      user_relations = current_user.get_my_relations_with_statuses([:new, :accepted, :refused], :all)
      user_ids = user_relations.map do |r|
        if current_user.id ==  r.user_from_id
          r.user_to_id
        else
          r.user_from_id
        end
      end
      @users = User.where(id: user_ids).page(params[:page])
    end
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
    @generated_passwd = Utils.generate_random_password(16)
    @user = User.new(user_params)
    @user.password = @generated_passwd
    @user.password_confirmation = @generated_passwd
    @user.add_role :player

    respond_to do |format|
      if @user.save
        # Send email
        UserMailer.welcome_and_account_credentials(@user, new_user_session_url).deliver

        format.html { redirect_to users_path, notice: t('user.controller.user_create_success') }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :update, @user

    if @user.update_attributes params[:password].blank? ? user_params.except(:password, :password_confirmation) : user_params # update_attributes params[:user]
      if is_admin?
        redirect_to users_path, :notice => t('user.controller.update_succeed')
      else
        redirect_to root_path, :notice => t('user.controller.update_succeed')
      end
    else
      if is_admin?
        redirect_to users_path, :alert => t('user.controller.update_failed')
      else
        redirect_to root_path, :alert => t('user.controller.update_failed')
      end
    end
  end
    
  def destroy
    user = User.friendly.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  # Email hinter
  #
  # @param [String] email
  # @return email hints
  # @ajax
  def email_hinter
    emails = User.where('email LIKE ?', "%#{params[:email]}%").limit(20).map {|e| e.email}

    render json: {emails: emails, input_id: params[:input_id]}.to_json
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end