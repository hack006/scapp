class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :build_menu

  # Set default url options for url_helpers
  #   - can be overridden by passing params to link_to or form_for
  def default_url_options
    unless Rails.env.test?
      { :host => Settings.app.host, :port => Settings.app.port }
    else
      {}
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    # user without role would cause redirect loop
    if current_user && current_user.roles.where(name: User::USER_ROLES).count.zero?
      redirect_to root_path
    else
      unless request.path == dashboard_path
        redirect_to dashboard_path, :alert => 'You don\'t have required permissions!'
      else
        redirect_to new_user_session_path, :alert => 'Please, sign in!'
      end
    end
  end

  rescue_from Mysql2::Error do |exception|
    logger.error "Mysql error occured: #{exception.message}." +
                 " [controller: #{controller_name}, action: #{action_name}, user_id: #{current_user.nil? ? '-' : current_user.id}]"
    redirect_to dashboard_path, :alert => t('errors.mysql_error')
  end

  if Rails.env == :production
    # Handle other unexpected ERRORS to prevent complete app crash
    rescue_from StandardError do |exception|
      # TODO send notification to admin
      logger.error "Following error raised: #{exception.message}." +
                   " [controller: #{controller_name}, action: #{action_name}, user_id: #{current_user.nil? ? '-' : current_user.id}]"
      redirect_to dashboard_path, :alert => t('errors.critical_error')
    end
  end

  # Set up redirect path after successful signin
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  # GLOBAL AVAILABLE HELPERS
  # =====>
  helper_method :is_watcher?, :is_player?, :is_coach?, :is_admin?

  def is_coach?
    return false if current_user.blank?
    current_user.has_role? :coach
  end

  def is_player?
    return false if current_user.blank?
    current_user.has_role? :player
  end

  def is_watcher?
    return false if current_user.blank?
    current_user.has_role? :watcher
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

  def set_locale
    I18n.locale = current_user.locale.code unless current_user.blank?
    I18n.locale = params[:locale] unless params[:locale].blank?
  end

  def build_menu
    @menu = AdvancedMenu::Menu.new()
  end
end
