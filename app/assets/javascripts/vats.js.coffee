# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready ->
  # hide range options if is not time limited
  status = jQuery("#vat_is_time_limited").parent().attr('aria-checked')
  if status == "false"
    jQuery('#vat-time-validity-range').hide()

  jQuery("#vat_is_time_limited").parent().find('.iCheck-helper').on('click', ->
    # get check status
    status = jQuery("#vat_is_time_limited").parent().attr('aria-checked')
    if status == "true"
      jQuery('#vat-time-validity-range').show(300)
    else
      jQuery('#vat-time-validity-range').hide(300)
  )