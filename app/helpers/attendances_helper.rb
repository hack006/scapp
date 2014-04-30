module AttendancesHelper
  def self.labelize_participation_state(state)
    case state
      when :invited
        "<span class=\"label label-grey\">#{I18n.t("attendance.participation.invited")}</span>"
      when :signed
        "<span class=\"label label-primary\">#{I18n.t("attendance.participation.signed")}</span>"
      when :present
        "<span class=\"label label-success\">#{I18n.t("attendance.participation.present")}</span>"
      when :excused
        "<span class=\"label label-warning\">#{I18n.t("attendance.participation.excused")}</span>"
      when :unexcused
        "<span class=\"label label-danger\">#{I18n.t("attendance.participation.unexcused")}</span>"
    end
  end
end
