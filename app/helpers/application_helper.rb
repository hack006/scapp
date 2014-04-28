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

  # Wraps remaining time in label and highlight with warning colors
  #
  # @param [DateTime] date_time specific time which is compared current
  # @return [String] remaining time wrapped in span
  def self.labelize_time_remain(date_time)
    cur = DateTime.current
    seconds = (date_time.to_i - cur.to_i).to_f
    minutes = (seconds / 1.minute).round
    hours = (seconds / 1.hour).round(1)
    days = (seconds / 1.day).round(1)

    if seconds < 0
      ret = "<span class=\"label label-danger\">#{I18n.t('dictionary.passed')}</span>"
    elsif seconds < 1.hour
      ret = "<span class=\"label label-warning\">#{I18n.t('dictionary.remain')} #{I18n.t('times.minutes', count: minutes)}</span>"
    elsif seconds < 1.day
      ret = "<span class=\"label label-success\">#{I18n.t('dictionary.remain')} #{I18n.t('times.hours', count: hours)}</span>"
    else
      ret = "<span class=\"label label-success\">#{I18n.t('dictionary.remain')} #{I18n.t('times.days', count: days)}</span>"
    end

    ret
  end

  # Create help link
  #
  # @param [String] theme main topic - exist as file inside helps views
  # @param [String] keyword term we show help for - exist es keyword with description isnise theme file
  # @param [String] locale specify language version of help file to pick up
  # @return [String] html snippet required to link us to help page and scroll to anchor
  def self.link_help(theme, keyword, locale = 'en')
    # TODO implement anchor from keyword
    "(<a href=\"#{Rails.application.routes.url_helpers.show_help_path(locale, theme)}\" target=\"_blank\"><i class=\"fa fa-question-circle\"></i><span> help</span></a>)"
  end

  # Create help modal link
  #
  #   Do not forget to add html snippet to page: #modal-help.modal.fade{role: 'dialog', 'aria-hidden' => true}
  #
  # @param [String] theme main topic - exist as file inside helps views
  # @param [String] keyword term we show help for - exist es keyword with description isnise theme file
  # @param [String] locale specify language version of help file to pick up
  # @return [String] html snippet required to fetch help and display it to modal window
  def self.link_modal_help(theme, keyword, locale = 'en')
    "(<a href=\"#{Rails.application.routes.url_helpers.show_modal_help_path(locale, theme)}\" data-toggle=\"modal\" data-target=\"#modal-help\">
      <i class=\"fa fa-question-circle\"></i><span> help</span>
    </a>)"
  end

  # Colorize specified text against positive or negative value
  #
  # @param [String] text Text to colorise
  # @param [Float] value Numeric value determining result color
  # @return [String] Colorized text wrapped in span
  def self.colorize_negative_positive(text, value)
    raise StandardError, 'Numeric value is required!' unless value.kind_of?(Float) || value.kind_of?(Integer) || (value.kind_of?(String) && value.is_number?)

    out = "<span class=\"#{value < 0 ? 'negative' : ''}#{value == 0 ? 'neutral' : ''}#{value > 0 ? 'positive' : ''}\">"
    out += "<i class=\"fa fa-long-arrow-down\"></i>" if value < 0
    out += "<i class=\"fa fa-long-arrow-up\"></i>" if value > 0
    out += " #{text}</span>"
  end

end
