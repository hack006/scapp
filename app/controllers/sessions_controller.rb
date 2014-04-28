class SessionsController < Devise::SessionsController
  layout 'application_plain'

  def new
    super
    # TODO log
  end

  def create
    super
    # TODO log
  end

  def destroy
    super
    # TODO log
  end

end