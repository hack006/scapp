class PasswordsController < Devise::PasswordsController
  layout 'application_plain'
  before_filter :sanitized_params, if: :devise_controller?

  def new
    authorize! :new, PasswordsController
    super
  end

  def create
    authorize! :create, PasswordsController
    super
  end

  def sanitized_params
    devise_parameter_sanitizer.for(:new) {|u| u.permit(:email)}
  end

  # Set default url options for url_helpers
  #   - can be overridden by passing params to link_to or form_for
  def default_url_options
    { :host => Settings.app.host, :port => Settings.app.port }
  end

end
