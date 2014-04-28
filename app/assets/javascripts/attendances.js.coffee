# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready( ->
  # colorify row based on selected attendance
  jQuery("td.attendance-state .iCheck-helper").on('click', ->
    state = jQuery(this).parent().find('input').val()
    jQuery(this).parent().parent().parent().attr('class', 'state-' + state)
  )

  # recalculation of price with VATs and balance
  jQuery("table.attendance-payments input.price-without-vat").on('keyup', ->
    arr = this.id.split('_')
    id = arr[arr.length - 1]
    price_without_vat = this.value

    # recalculate value with VAT
    jQuery("#attendance_payment_with_vat_#{id}").val("#{price_without_vat * vat_multiplier} #{currency}")

    # recalculate scheduled lesson balance
    income = 0
    jQuery("table.attendance-payments input.price-without-vat").each( ->
      if jQuery.isNumeric(parseFloat(this.value))
        income = income + parseFloat(this.value)
    )
    price_balance = income - total_lesson_costs
    if price_balance < 0
      jQuery("#balance span.price").removeClass('positive')
      jQuery("#balance span.price").addClass('negative')
    else if price_balance >= 0
      jQuery("#balance span.price").addClass('positive')
      jQuery("#balance span.price").removeClass('negative')

    jQuery("#balance span.price").text("#{price_balance} #{currency}")
  )

  # usage of old player price value
  jQuery('a[data-set-old-player-price]').on('click', ->
    val = jQuery(this).attr('data-set-old-player-price')
    jQuery(this).parent().parent().find('input.price-without-vat').val(val).trigger('keyup')
  )

  if @attendance_graph_data == undefined
    @attendance_graph_data = { }

  # Training summary graph plot
  if jQuery("#morris-chart-attendance-summary").size() > 0
    jQuery("#morris-chart-attendance-summary").highcharts({
      chart: {
        zoomType: 'x',
        spacingRight: 20
      },
      title: {
        text: null
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
      plotOptions: {
        column: {
          stacking: 'normal'
        }
      },
      series: [
        {
          type: 'column',
          name: 'Present players',
          data: attendance_graph_data.present,
          color: 'green'
        },
        {
          type: 'column',
          name: 'Excused players',
          data: attendance_graph_data.excused,
          color: 'yellow'
        },
        {
          type: 'column',
          name: 'Unexcused players',
          data: attendance_graph_data.unexcused,
          color: 'red'
        }],
      tooltip: {
        formatter: ->
          date = new Date(this.x)
          "<strong>Date:</strong> #{date.to_fstring()}<br/> <strong>Players:</strong> #{this.y}"
      }
    });

  if jQuery("#morris-chart-attendance-finance").size() == 1
    # Training finance graph plot
    cost_series = []
    keys = Object.keys(attendance_graph_data.costs)

    if keys.length == 1

      cost_series.push(
        {
          type: 'area',
          name: 'Costs [' + keys[0] + ']',
          data: attendance_graph_data.costs[keys[0]],
          fillOpacity: 0.3,
          color: '#FF0000'
        }
      )
    else
      for key in keys
        cost_series.push(
          {
            id: key,
            type: 'area',
            name: 'Costs [' + key + ']',
            data: attendance_graph_data.costs[key],
            fillOpacity: 0.3,
            color: '#FF0000'
          }
        )

    jQuery("#morris-chart-attendance-finance").highcharts({
      chart: {
        zoomType: 'x',
        spacingRight: 20
      },
      title: {
        text: null
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
          text: "Price"
        }
      },
      plotOptions: {
        area: {
          fillOpacity: 0.5
        }
      },
      series: [
        {
          id: '1',
          type: 'area',
          name: 'Income [' + keys[0] + ']',
          data: attendance_graph_data.income,
          fillOpacity: 0.3,
          color: '#00FF00'
        }
      ].concat(cost_series),
      tooltip: {
        shared: true,
        formatter: ->
          date = new Date(this.x)
          if this.points.length == 2 && this.points[0].point.currency == this.points[1].point.currency
            balance = this.points[0].y - this.points[1].y
          else
            balance = 'NA'

          out = "<strong>Date:</strong> #{date.to_fstring()}<br/> <strong>Income:</strong> #{this.points[0].y} #{this.points[0].point.currency}<br/> <strong>Costs:</strong><br />"
          for key in [1..(this.points.length - 1)]
            out += "   >> #{this.points[key].y} #{this.points[key].point.currency}<br />"

          out += "<br/> <strong>BALANCE:</strong> #{balance} #{this.points[0].point.currency}"
      }
    });

)
