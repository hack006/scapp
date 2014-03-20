module UserRelationsHelper

  # Wraps status to label with specific color
  # @param [String] label label to labelize
  # @return [String] label wrapped in label span
  def self.labelize_relation_status(label)
    case label
      when 'new'
        return '<span class="label label-warning">new</span>'
      when 'accepted'
        return '<span class="label label-success">accepted</span>'
      when 'refused'
        return '<span class="label label-danger">refused</span>'
      else
        return label
    end
  end

  # Wraps relation type to label with specific color
  # @param [String] label label to labelize
  # @return [String] label wrapped in label span
  def self.labelize_relation(label)
    case label
      when :watcher
        return '<span class="label label-light-grey">watcher</span>'
      when :friend
        return '<span class="label label-mid-grey">friend</span>'
      when :coach
        return '<span class="label label-grey">coach</span>'
      else
        return label
    end
  end
end