module TrainingLessonsHelper

  # Return day highlighted in table for quicker reading
  #
  # @param [Symbol] day week day abbreviation
  #   @option :mon
  #   @option :tue
  #   @option :wed
  #   @option :thu
  #   @option :fri
  #   @option :sat
  #   @option :sun
  # @param [Symbol] size size of widget
  #   @option :default
  #   @option :smaller
  # @return [String] graphic output - table based
  def self.day_in_week_graphic_display(day, size = :default)
  days = TrainingLesson::DAYS

  case size
    when :smaller
      widget = '<table class="week-days-widget smaller"><tbody><tr>'
    else
      widget = '<table class="week-days-widget"><tbody><tr>'
  end

  days.each do |d|
    if d == day
      widget += "<td class=\"week-day active\">#{d.to_s.upcase}</td>"
    else
      widget += "<td class=\"week-day\">#{d.to_s.upcase}</td>"
    end
  end
  widget += '</tr></tbody></table>'
  end

  def self.training_progress(from_date, until_date)
    days = (until_date - from_date) / 1.day
    days_elapsed_from_beginning = (Date.current.to_time - from_date) / 1.day
    days_elapsed_from_beginning = 0 if days_elapsed_from_beginning < 0
    days_elapsed_from_beginning = days if days_elapsed_from_beginning > days

    if days_elapsed_from_beginning > days
      percentage = 100
    else
      percentage = (days_elapsed_from_beginning / days * 100).round
    end

    output = <<EOF
      <div class="progress">
        <div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="#{percentage}" aria-valuemin="0" aria-valuemax="100" style="width: #{percentage}%">
        </div>
      </div>
      <small>#{I18n.t('training_lesson.helper.remaining_days', { count: days_elapsed_from_beginning.round(1), days: days })}</small>
EOF
    output
  end

end
