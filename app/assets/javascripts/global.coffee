jQuery(document).ready( ->

  # AJAX ERROR -> set flash message
  jQuery("a[data-flash-error!=false]").on('ajax:error', (event, state, xhr) ->
    # if error container doesn't exist in DOM then create it
    if jQuery('#flash-message').size() == 0
      jQuery('aside.right-side').prepend('<div id="flash-message" class="alert alert-danger"></div>')

    jQuery('#flash-message').html('<strong>AJAX error</strong>. Action call failed. Please, try again.')

  )
)

#
# Return a timestamp with the format "m/d/yy h:MM:ss TT"
# based on snippet: https://gist.github.com/hurjas/2660489
# @type {int} Timestamp
#

Date::to_fstring = ->
  # Create a date object with the current time
  datum = new Date(@)

  # Create an array with the current month, day and time
  date = [ datum.getFullYear(), datum.getMonth() + 1, datum.getDate() ]

  # Create an array with the current hour, minute
  time = [ datum.getHours(), datum.getMinutes(), datum.getSeconds() ]

  # If seconds and minutes are less than 10, add a zero
  for i in [1..2]
    if ( time[i] < 10 )
      time[i] = "0#{time[i]}"

  "#{date.join("/")} #{time.join(":")}"