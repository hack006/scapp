module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  # Get _object_ value of specified _field_ or dash when _field_ not available or empty
  #
  # Designed especially for data retrieved as {ActiveRecord::Relation}
  #
  # @return [String]
  def dash_or_value(object, field)
    return "-" if object.blank?
    return "-" unless object.class.attribute_names.include?(field.to_s) && !object[field].empty?
    object[field]
  end

  # Wraps public status into label with specific color
  # @param [String] label label to labelize
  # @return [String] label wrapped in label span
  def self.labelize_boolean(label)
    case label
      when true
        return '<span class="label label-success">✓</span>'
      when false
        return '<span class="label label-danger">✗</span>'
    end
  end

end
