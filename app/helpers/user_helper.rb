module UserHelper

  # Wraps user role to label with specific color
  # @param [Role] role role to labelize
  # @return [String] label wrapped in label span
  def self.labelize_user_role(role)
    case role.name
      when 'watcher'
        return '<span class="label label-success">watcher</span>'
      when 'player'
        return '<span class="label label-info">player</span>'
      when 'coach'
        return '<span class="label label-primary">coach</span>'
      when 'admin'
        return '<span class="label label-danger">admin</span>'
      else
        return label
    end
  end

  # Wraps user old to label with specific color
  # @param [User] user user to labelize
  # @return [String] user old in years or NA when birthday not set wrapped in label span
  def self.labelize_user_old(user)
    unless user.birthday.blank?
      old_years = ( (Date.current - user.birthday.to_date) / (1.year / 1.day) ).round(1)

      case old_years
        when 0..9
          return '<span class="label label-success">' + I18n.t('times.years', count: old_years) + '</span>'
        when 10..14
          return '<span class="label label-info">' + I18n.t('times.years', count: old_years) + '</span>'
        when 15..17
          return '<span class="label label-primary">' + I18n.t('times.years', count: old_years) + '</span>'
        when 18..99
          return '<span class="label label-danger">' + I18n.t('times.years', count: old_years) + '</span>'
        else
          return label
      end
    else
      return '<span class="label label-light-grey">NA</span>'
    end
  end

end