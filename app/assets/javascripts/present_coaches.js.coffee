# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready(->
  jQuery("a[data-load-coach-form]").on('click', ->
    coach_data = regular_coaches[jQuery(this).attr('data-load-coach-form')]
    jQuery('#present_coach_salary_without_tax').val(coach_data['wage_without_tax'])
    jQuery('#present_coach_vat_id').val(coach_data['vat_id'])
    jQuery('#present_coach_currency_id').val(coach_data['currency_id'])
    jQuery('#present_coach_user_email').val(coach_data['user_email'])
  )
)