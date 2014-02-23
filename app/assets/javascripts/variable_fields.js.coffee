# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).on('page:change', ->
  # display form for adding new category
  jQuery("#show-add-new-field-category").click ->
    jQuery("#add-new-field-category").show(300, ->
      jQuery("#add-new-field-category input#variable_field_category_name").focus()
    )
)

jQuery(document).ready( ->
  # = LIST EVENTS
  # == graph
  jQuery("a[data-chart=lvf]").on('ajax:send', (event, xhr) ->
    chart_id = jQuery(this).attr('data-chart-id')
    # firstly deactivate all tabs and navbar links
    jQuery('#vf-' + chart_id + ' .tab-pane').removeClass('active')
    jQuery('#vf-' + chart_id + ' .nav.nav-tabs li.active').removeClass('active')

    # secondly activate graph tab and chart link
    jQuery('#chart-' + chart_id).addClass('active')
    jQuery(this).parent().addClass('active')

    # show loading state
    jQuery('#chart-' + chart_id).html('<img src="/img/ajax-loader.gif" class="center" />')
  )
  jQuery("a[data-chart=lvf]").on('ajax:success', (event, data, status, xhr) ->
    chart_id = jQuery(this).attr('data-chart-id')

    # replace content by obtained data
    jQuery('#' + data.refresh_id).html('<div id="morris-chart-' + chart_id + '"></div>')

    new Morris.Line({
      # ID of the element in which to draw the chart.
      element: 'morris-chart-' + chart_id,
      # Chart data records -- each entry in this array corresponds to a point on
      # the chart.
      data: data.data,
      # The name of the data record attribute that contains x-values.
      xkey: 'measured_at',
      # A list of names of data record attributes that contain y-values.
      ykeys: ['int_value'],
      # Labels for the ykeys -- will be displayed when you hover over the
      # chart.
      labels: ['Value']
    });

    # TODO: change tab to normal one - prevent repetable loading
  )

)