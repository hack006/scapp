class CoachObligationNotExistError < StandardError
  def message
    I18n.t('errors.coach_obligation_not_exist_error')
  end
end