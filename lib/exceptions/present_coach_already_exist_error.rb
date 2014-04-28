class PresentCoachAlreadyExistError < StandardError
  def message
    I18n.t('errors.present_coach_already_exist_error')
  end
end