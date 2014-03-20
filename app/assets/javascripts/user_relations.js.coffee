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
        data : JSON.stringify({email: this.value, input_id: "#{this.id}"}),
        dataType: "json",
        url: "/users/email_hinter"
      }).done((ret) ->

        guesses_container_id = "#{ret['input_id']}_guesses"
        input_field_id = ret['input_id']

        if jQuery("##{guesses_container_id}").length == 0
          jQuery("##{input_field_id}").after("<div id=\"#{guesses_container_id}\"></div>")

        # show hints
        jQuery("##{guesses_container_id}").html("") # empty
        for email in ret['emails']
          jQuery("##{guesses_container_id}").append("<span class=\"label label-primary email-guess\">#{email}</span>")


        jQuery("span.email-guess").on("click", ->
          jQuery("##{input_field_id}").val(this.innerText)
        )
      )
  )
)