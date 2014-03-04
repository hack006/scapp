class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    unless request.path == root_path
      redirect_to root_path, :alert => 'You don\'t have required permissions!'
    else
      redirect_to new_user_session_path, :alert => 'Please, sign in!'
    end
  end

  # GLOBAL AVAILABLE HELPERS
  # =====>
  helper_method :is_coach?, :is_player?, :is_admin?

  def is_coach?
    return false if current_user.blank?
    current_user.has_role? :coach
  end

  def is_player?
    return false if current_user.blank?
    current_user.has_role? :player
  end

  def is_admin?
    return false if current_user.blank?
    current_user.has_role? :admin
  end
  # =====//

  private

  def current_ability
    @current_ability ||= Ability.new(current_user, request)
  end
end
