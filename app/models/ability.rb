class Ability
  include CanCan::Ability

  def initialize(user, request)

    # disable all
    cannot :manage, :all


    @user = user || User.new # for guest
    @request ||= request

    # set not role based permissions
    role_independent

    # set role based permissions
    @user.roles.each do |role|
      send role.name if ['player', 'coach', 'admin'].include? role.name
    end

    if @user.roles.size == 0
      # =======================================
      # GUEST PERMISSIONS
      # =======================================
      can [:new, :create], RegistrationsController
    end

  end

  # ===========================================
  # ROLE INDEPENDENT PERMISSIONS
  #
  # This is used for permissions which directly
  # don't rely on user role.
  #
  # ===========================================
  def role_independent
    # =============
    # VariableField
    #==============
    # @4.3 - can only view own VF page
    can [:user_variable_fields], VariableFieldsController if @request.params[:user_id] == @user.slug
    can [:show, :edit, :update, :delete], VariableField do |vf|
      # can manage only own VF - @4.2, @4.7, @4.8, @4.9, @4.10
      vf.user_id ==  @user.id
    end

  end

  # ===========================================
  # PLAYER PERMISSIONS
  # ===========================================
  def player
    can [:index], HomeController
    # =============
    # VariableField
    # =============
    can [:index, :new, :create, :show], VariableField # @4.1, @4.2, @4.5 - must be controlled in controller, @4.6


    # =============
    # User
    # =============
    can [:edit, :update], User do |user|
      user.id == @user.id
    end
    can [:show], User do |user|
      (user.id == @user.id) || @user.in_relation?(user, :friend) || @user.in_relation?(user, :coach) || @user.in_relation?(user, :watcher)
    end
  end

  # ===========================================
  # COACH PERMISSIONS
  #
  # Inherits all permissions from player
  # Add or modify inherited permissions
  #
  # ===========================================
  def coach
    # INHERIT from :player
    player() unless @user.has_role? :player

    # =============
    # VariableField
    # =============
    # can only VF page of users connected to him
    if @request.params.has_key?(:user_id) &&
        ((@request.params[:user_id] == @user.slug) || @user.in_relation?(User.friendly.find(@request.params[:user_id]), 'coach'))
      can [:user_variable_fields], VariableFieldsController
    end

    # =============
    # User
    # =============
    can [:index], User

  end

  # ===========================================
  # ADMIN PERMISSIONS
  #
  # Inherits all permissions from coach
  # Add or modify inherited permissions
  #
  # ===========================================
  def admin
    # INHERIT from :coach
    coach() unless @user.has_role? :coach


    can :manage, :all

    # =============
    # VariableField
    # =============
    can :show, VariableField # @4.2

    # =============
    # User
    # =============
    # no additional permission

  end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
end
