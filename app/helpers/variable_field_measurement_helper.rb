module VariableFieldMeasurementHelper

  # Return measurement old formatted to label
  #
  # @param [DateTime] time
  def self.labelize_measurement_old(time)
    time_seconds = (DateTime.current.to_i - time.to_datetime.to_i).to_f
    time_minutes = time_seconds / 1.minute
    time_hours = time_seconds / 1.hour
    time_days = time_seconds / 1.day


    if time_minutes < 60
      "<span class=\"label label-success\">#{I18n.t('dictionary.before')} #{I18n.t('times.minutes', count: time_minutes.round(1))}</span>"
    elsif time_hours < 24
      "<span class=\"label label-success\">#{I18n.t('dictionary.before')} #{I18n.t('times.hours', count: time_hours.round(1))}</span>"
    elsif time_days < 7
      "<span class=\"label label-success\">#{I18n.t('dictionary.before')} #{I18n.t('times.days', count: time_days.round(1))}</span>"
    elsif time_days < 30
      "<span class=\"label label-warning\">#{I18n.t('dictionary.before')} #{I18n.t('times.days', count: time_days.round(1))}</span>"
    else
      "<span class=\"label label-danger\">#{I18n.t('dictionary.before')} #{I18n.t('times.days', count: time_days.round(1))}</span>"
    end
  end

end