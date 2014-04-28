class HelpsController < ApplicationController
  before_action :set_locale

  def index
    authorize! :index, HelpsController

    @help_files = []
    Dir.foreach(Rails.root.join('app','views','helps')).each do |f|
      (f_name, f_locale) = f.split('.')

      # drop index and partials
      if !f_name.blank? && f_name != 'index' && f_name[0] != '_' && f_locale == @locale
        @help_files << f_name
      end
    end

    @help_files.sort!
  end

  def show
    authorize! :show, HelpsController

    get_template_file

    unless @help_filename.blank?
      render @help_filename
    else
      redirect_to dashboard_path, alert: t('helps.controller.not_found')
    end

  end

  def show_ajax
    authorize! :show_ajax, HelpsController

    get_template_file

    unless @help_filename.blank?
      render @help_filename, layout: 'layouts/modal'
    else
      render partial: 'not_found', template: 'layouts/modal'
    end

  end

  private

    def get_template_file()
      @theme = params[:theme]
      @help_filename = "#{@theme}.#{@locale}.html.haml"

      @help_filename = nil unless File.exists?(Rails.root.join('app','views','helps') + @help_filename)
    end

    # Set provided locale via url param
    def set_locale
      @locale = params[:locale]
      @locale ||= 'en'
    end
end