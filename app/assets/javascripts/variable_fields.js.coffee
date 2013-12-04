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