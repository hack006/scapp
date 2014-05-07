class UserMailer < ActionMailer::Base

  def welcome_and_account_credentials(user, login_url)
    @user = user
    @login_page = login_url
    mail(from: Settings.app.email.default, to: @user.email, subject: 'Welcome to ScApp')
  end
end
