# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


build_table_from_json = (heading, rows, options = null) ->
  css_class = options["class"] ? ""
  build = "<table class='#{css_class}'><thead><tr>";
  # add heading
  for h in heading
    build += "<th>" + h + "</th>"

  build += "</tr>"
  build += "</thead><tbody>"
  # add table data
  for row in rows
    build += "<tr>"
    for f in row
      build += "<td>" + f + "</td>"
    build += "</tr>"
  build += "</tbody></table>"

jQuery(document).ready( ->
  # = ADD VARIABLE FIELD =
  # ======================
  jQuery("#show-add-new-field-category").click ->
    jQuery("#add-new-field-category").show(300, ->
      jQuery("#add-new-field-category input#variable_field_category_name").focus()
    )

  # = LIST EVENTS =
  # ===============

  # == GRAPH ==
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
    table_id = jQuery(this).attr('data-chart-id')

    # replace content by obtained data
    jQuery('#' + data.refresh_id).html('<div id="morris-chart-' + table_id + '"></div>')

    jQuery("#morris-chart-#{table_id}").highcharts({
      chart: {
        zoomType: 'x',
        spacingRight: 20
      },
      title: {
        text: 'Change of variable in time'
      },
      xAxis: {
        type: 'datetime',
        maxZoom: 7 * 24 * 3600000, # fourteen days
        title: {
          text: null
        }
      },
      yAxis: {
        title: {
          text: 'Value'
        }
      },
      series: [{
        type: 'line',
        name: 'Measured values',
        data: data.data.graph
      },
      {
        type: 'line',
        name: 'Regression line',
        color: '#F7CB9C',
        earker: {
          enabled: false
        },
        marker: {
          enabled: false
        },
        enableMouseTracking: false,
        data: data.data.regression
      }],
      tooltip: {
        formatter: ->
          date = new Date(this.x)
          "<strong>Date:</strong> #{date.to_fstring()}<br/> <strong>Value:</strong> #{this.y}<br/><strong>Location:</strong> #{this.point.location}"
      }
    });
  )
  # == TABLE ==
  jQuery("a[data-table=lvf]").on('ajax:send', (event, xhr) ->
    table_id = jQuery(this).attr('data-table-id')
    # firstly deactivate all tabs and navbar links
    jQuery('#vf-' + table_id + ' .tab-pane').removeClass('active')
    jQuery('#vf-' + table_id + ' .nav.nav-tabs li.active').removeClass('active')

    # secondly activate graph tab and chart link
    jQuery('#table-' + table_id).addClass('active')
    jQuery(this).parent().addClass('active')

    # show loading state
    jQuery('#table-' + table_id).html('<img src="/img/ajax-loader.gif" class="center" />')
  )
  jQuery("a[data-table=lvf]").on('ajax:success', (event, data, status, xhr) ->
    table_id = jQuery(this).attr('data-table-id')

    # replace content by obtained data
    jQuery('#' + data.refresh_id).html(build_table_from_json(data.heading, data.data, {class: "table table-striped"}))

  )

    # TODO: change tab to normal one - prevent repetable loading

)