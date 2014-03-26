module UserGroupsHelper

  # Wraps visibility to label with specific color
  # @param [String] label label to labelize
  # @return [String] label wrapped in label span
  def self.labelize_group_visibility(label)
    case label
      when 'public'
        return '<span class="label label-success">public</span>'
      when 'registered'
        return '<span class="label label-info">registered</span>'
      when 'members'
        return '<span class="label label-warning">members</span>'
      when 'owner'
        return '<span class="label label-primary">owner</span>'
      else
        return label
    end
  end

end