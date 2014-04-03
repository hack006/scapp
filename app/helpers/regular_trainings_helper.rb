module RegularTrainingsHelper

  # Visualize training days
  #
  # @param [RegularTraining] regular_training
  def self.visualize_training_days(regular_training)
    active_days = { mon: false, tue: false, wed: false, thu: false, fri: false, sat: false, sun: false }
    regular_training.training_lessons.each { |l| active_days[l.day] = true }

    widget = '<table class="regular-training-lessons-in-week-widget"><tr>'
    active_days.each do |day, is_active|
      widget += "<td class=\"#{is_active ? 'active' : ''}\">#{day.upcase}</td>"
    end

    widget += '</tr></table>'
  end

end