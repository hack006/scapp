class UserRelationsController < ApplicationController
  before_action :set_user_relation, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource except: [:user_has, :new_request, :create_request, :create]

  # GET /user_relations
  # GET /user_relations.json
  def index
    @user_relations = UserRelation.all.order(created_at: :desc).page(params[:page])
  end

  # GET /user_relations/1
  # GET /user_relations/1.json
  def show
  end

  # GET /user_relations/new
  def new
    @user_relation = UserRelation.new
  end

  # GET /user_relations/1/edit
  def edit
    # fill readonly fields
    @user_relation.first_user = @user_relation.from.email
    @user_relation.second_user = @user_relation.to.email
  end

  # POST /user_relations
  # POST /user_relations.json
  def create
    authorize! :create, UserRelation

    @user_relation ||= UserRelation.new(user_relation_params)
    @user_relation.first_user = params[:user_relation][:first_user]
    @user_relation.second_user = params[:user_relation][:second_user]

    # test if given email addresses are valid
    first_user = User.where(email: params[:user_relation][:first_user]).first
    unless @user_relation.valid? && !params[:user_relation][:first_user].blank? && first_user
      flash[:error] = t('user_relations.controller.not_valid_user') unless first_user
      render action: 'new'
      return
    end

    second_user = User.where(email: params[:user_relation][:second_user]).first
    unless @user_relation.valid? && !params[:user_relation][:second_user].blank? && second_user
      flash[:error] = t('user_relations.controller.not_valid_user') unless second_user
      render action: 'new'
      return
    end

    @user_relation.from = first_user
    @user_relation.to = second_user

    # only one relation between 2 users of one relation type i permitted
    if UserRelation.where(from: @user_relation.from, to: @user_relation.to, relation: @user_relation.relation).count > 0
      flash[:error] = t('user_relations.controller.already_exists', {type: @user_relation.relation, user: @user_relation.to.name})
      render action: 'new'
      return
    end

    respond_to do |format|
      if @user_relation.save
        format.html { redirect_to user_relations_path, notice: t('user_relations.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @user_relation }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_relations/1
  # PATCH/PUT /user_relations/1.json
  def update
    respond_to do |format|
      if @user_relation.update(user_relation_params)
        format.html { redirect_to user_relations_path, notice: t('user_relations.controller.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_relations/1
  # DELETE /user_relations/1.json
  def destroy
    @user_relation.destroy
    respond_to do |format|
      format.html { redirect_to user_relations_url, notice: t('user_relations.controller.successfully_removed') }
      format.json { head :no_content }
    end
  end

  # List relations user has
  #
  # Can access only owner, :coach, :admin
  #
  # @param [string] :user_id - friendly_id slug
  # @controller_action
  def user_has
    authorize! :user_has, UserRelation

    @user = User.friendly.find(params[:user_id])

    @relations ||= Hash.new
    @relations[:accepted] = @user.get_my_relations_with_statuses('accepted', :all).page(params[:active_rel_page]).per(10)
    @relations[:new] = @user.get_my_relations_with_statuses('new', :all).page(params[:new_rel_page]).per(10)
    @relations[:refused] = @user.get_my_relations_with_statuses('refused', :all).page(params[:refused_rel_page]).per(10)

    @count ||= Hash.new
    @count[:accepted] = @user.get_my_relations_with_statuses('accepted', :all).count
    @count[:new] = @user.get_my_relations_with_statuses('new', :all).count
    @count[:refused] = @user.get_my_relations_with_statuses('refused', :all).count

    render 'users/user_relations/has'
  end

  # Change status of relation
  #
  # Changes for currently logged user, other side of relation let untouched
  #
  # @param [Integer] id User relation id
  # @param [String] status Status to set
  # @controller_action
  def change_status
    not_authorized = false
    # decide which side of connection we manipulate
    if @user_relation.from == current_user
      @user_relation.from_user_status = params[:status]
    elsif @user_relation.to == current_user
      @user_relation.to_user_status = params[:status]
    elsif is_admin?
      # set both sides of connection
      @user_relation.from_user_status = params[:status]
      @user_relation.to_user_status = params[:status]
    else
      not_authorized = true
    end

    respond_to do |format|
      if not_authorized
        format.html { redirect_to @user_relation, notice: t('user_relations.change_status.not_authorized') }
        format.json { render json: {error: t('user_relations.change_status.not_authorized')}.to_json, status: :unprocessable_entity }
      elsif @user_relation.save
        format.html { redirect_to user_user_relations_path(current_user), notice: t('user_relations.change_status.successfully_changed', status: params[:status]) }
        format.json { render action: 'show', status: :created, location: @user_relation }
      else
        format.html { redirect_to user_user_relations_path(current_user), notice: t('user_relations.change_status.unexpected_error') }
        format.json { render json: @user_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # Create new unconfirmed user relation (relation request)
  #
  # @controller_action
  def new_request
    authorize! :new_request, UserRelation

    @user_relation = UserRelation.new
  end

  def create_request
    authorize! :create_request

    @user_relation ||= UserRelation.new(user_relation_params)
    @user_relation.second_user = params[:user_relation][:second_user]
    # test if given email address valid
    second_user = User.where(email: params[:user_relation][:second_user]).first
    unless @user_relation.valid? && !params[:user_relation][:second_user].blank? && second_user
      flash[:error] = t('user_relations.controller.not_valid_user') unless second_user
      render action: 'new_request'
      return
    end

    @user_relation.from = current_user
    @user_relation.from_user_status = 'accepted'
    @user_relation.to = second_user

    # only one relation between 2 users of one relation type i permitted
    if UserRelation.where(from: @user_relation.from, to: @user_relation.to, relation: @user_relation.relation).count > 0
      flash[:error] = t('user_relations.controller.already_exists', {type: @user_relation.relation, user: @user_relation.to.name})
      render action: 'new_request'
      return
    end

    respond_to do |format|
      if @user_relation.save
        format.html { redirect_to user_user_relations_path(current_user), notice: t('user_relations.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @user_relation }
      else
        format.html { render action: 'new_request' }
        format.json { render json: @user_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_relation
      @user_relation = UserRelation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_relation_params
      params.require(:user_relation).permit(:relation, :from_user_status, :to_user_status)
    end
end
