class UserNotExistError < StandardError
  def message
    I18n.t('errors.user_not_exist_error')
  end
end