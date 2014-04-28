module TrainingLessonRealizationsHelper

  def self.labelize_status(status)
    case status
      when :scheduled
        '<span class="label label-info">scheduled</span>'
      when :canceled
        '<span class="label label-danger">canceled</span>'
      when :done
        '<span class="label label-success">done</span>'
    end
  end

  def self.days_until_start(date)
    remain_days = [-1, date - Date.current].max.to_int
    case remain_days
      when -1
        '<span class="label label-danger">' + I18n.t('training_realization.helper.in_the_past') + '</span>'
      when 0
        '<span class="label label-warning">' + I18n.t('training_realization.helper.today') + '</span>'
      else
        '<span class="label label-success">' + I18n.t('training_realization.helper.remain_days', count: remain_days) + '</span>'
    end
  end

  def self.get_regular_lesson_role(regular_lesson, user)
    if regular_lesson.regular_training.has_coach? user
      '<span class="label label-primary">coach</span>'
    elsif regular_lesson.regular_training.has_player? user
      '<span class="label label-info">player</span>'
    end
  end

  def self.get_individual_lesson_role(individual_scheduled_lesson, user)
    if individual_scheduled_lesson.user == user
      '<span class="label label-success">owner</span>'
    elsif individual_scheduled_lesson.attendances.where(user: user).any?
      '<span class="label label-info">player</span>'
    elsif individual_scheduled_lesson.present_coaches.where(user: user).any?
      '<span class="label label-primary">coach</span>'
    end
  end

end
