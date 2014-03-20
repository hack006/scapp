# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready( ->
  # Hook ajax email gueser
  jQuery("input[data-guesser=email").on("keyup", ->
    if this.value.length > 2
      # ajax request
      jQuery.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify({email: this.value}),
        dataType: "json",
        url: "/users/email_hinter"
      }).done((ret) ->
        # show hints
        jQuery("#email_guesses").html("") # empty
        for email in ret
          jQuery("#email_guesses").append("<span class=\"label label-primary email-guess\">#{email}</span>")

        jQuery("span.email-guess").on("click", ->
          jQuery("input[data-guesser=email").val(this.innerText)
        )
      )
  )
)