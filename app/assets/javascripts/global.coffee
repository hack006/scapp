jQuery(document).ready( ->

  # AJAX ERROR -> set flash message
  jQuery("a[data-flash-error!=false]").on('ajax:error', (event, state, xhr) ->
    # if error container doesn't exist in DOM then create it
    if jQuery('#flash-message').size() == 0
      jQuery('aside.right-side').prepend('<div id="flash-message" class="alert alert-danger"></div>')

    jQuery('#flash-message').html('<strong>AJAX error</strong>. Action call failed. Please, try again.')

  )
)