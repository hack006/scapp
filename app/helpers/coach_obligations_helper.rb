module CoachObligationsHelper

  # Labelize coach obligation role
  def self.labelize_coach_role(role)
    case role
      when :coach, 'coach'
        "<span class=\"label label-default\">#{I18n.t('coach_obligation.role.coach')}</span>"
      when :head_coach, 'head_coach'
        "<span class=\"label label-primary\">#{I18n.t('coach_obligation.role.head_coach')}</span>"
    end
  end

end
