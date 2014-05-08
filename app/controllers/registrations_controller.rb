class RegistrationsController < Devise::RegistrationsController
  layout 'application_plain'
  before_filter :update_sanitized_params, if: :devise_controller?

  def new
    authorize! :new, RegistrationsController
    super
  end

  def create
    authorize! :create, RegistrationsController
    super
    # registered user has to automatically get lowest privilege -> :player
    current_user.add_role :player unless current_user.nil?
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name, :email, :password, :password_confirmation, :current_password)}
  end

  # Override to add extend with locale
  def sign_up_params
    default_locale = Locale.where(code: Settings.app.default_locale).first
    devise_parameter_sanitizer.sanitize(:sign_up).merge(locale_id: default_locale.id)
  end

end
