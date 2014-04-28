module AttendancesHelper
  def self.labelize_participation_state(state)
    case state
      when :invited
        '<span class="label label-grey">invited</span>'
      when :signed
        '<span class="label label-primary">signed</span>'
      when :present
        '<span class="label label-success">present</span>'
      when :excused
        '<span class="label label-warning">excused</span>'
      when :unexcused
        '<span class="label label-danger">unexcused</span>'
    end
  end
end
