class Ability
  include CanCan::Ability

  def initialize(user, request)

    # disable all
    cannot :manage, :all


    @user = user || User.new # for guest
    @request ||= request

    @user.roles.each do |role|
      send role.name if ['player', 'coach', 'admin'].include? role.name
    end

    if @user.roles.size == 0
      #for guest without roles
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
    can [:index, :new, :create, :show], VariableField
    can [:update, :delete], VariableField do |vf|
      # can manage only own VF
      vf.user_id ==  @user.id
    end
    # can only view own VF page
    can [:user_variable_fields], VariableFieldsController if @request.params[:user_id] == @user.slug
  end

  # ===========================================
  # COACH PERMISSIONS
  # ===========================================
  def coach
    # INHERIT from :player
    player() unless @user.has_role? :player

    # =============
    # VariableField
    # =============
    can [:update, :delete], VariableField do |vf|
      # can manage only own VF
      vf.user_id ==  @user.id
    end

    # can only VF page of users connected to him
    if (@request.params[:user_id] == @user.slug) || @user.in_relation?(User.friendly.find(@request.params[:user_id]), 'coach')
      can [:user_variable_fields], VariableFieldsController
    end

  end

  # ===========================================
  # ADMIN PERMISSIONS
  # ===========================================
  def admin
    # INHERIT from :coach
    coach() unless @user.has_role? :coach

    # =============
    # VariableField
    # =============
    can :manage, :all
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
