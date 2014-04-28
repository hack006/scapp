class AttendancePlayerAlreadyExistError < StandardError
  def initialize(player)
    @player = player
  end

  def message
    I18n.t('errors.attendance_player_already_exist_error', user_id: @player.slug)
  end
end