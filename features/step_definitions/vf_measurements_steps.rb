And(/^I should see measurement with value "([^"]*)"$/) do |vf_value|
  found = false
  all(:css, '.vfm td.value').each do |v|
    if v.has_text? vf_value
      found = true
      break
    end
  end

  found.should be_true
end

And(/^I shouldn't see measurement with value "([^"]*)"$/) do |vf_value|
  found = false
  all(:css, '.vfm td.value').each do |v|
    if v.has_text? vf_value
      found = true
      break
    end
  end

  found.should be_false
end

And(/^I am at page listing my variables and measurements$/) do
  visit user_variable_fields_path @user[1]
end

When(/^I click on "(.*?)" for VF "(.*?)"$/) do |label, vf|
  find(".vf-name-#{vf}").find_link(label).click
end

When(/^I fill in all necessary measurement fields$/) do
  fill_in 'Location', with: 'Prague'
  fill_in 'Numeric value', with: '100'
end

And(/^I am at page listing user "([^"]*)" variables and measurements$/) do |user_name|
  user = User.where(name: user_name).first
  visit user_variable_fields_path user
end

And(/^I fill all required fields for variable field measurement for :player$/) do
  fill_in 'variable_field_measurement_measured_at', with: '1/1/2014 11:11'
  fill_in 'variable_field_measurement_locality', with: 'Prague'
  fill_in 'variable_field_measurement_int_value', with: 100
end

And(/^I set measurement_for to user test2$/) do
  select 'test2',from: 'variable_field_measurement_measured_for_id'
end

When(/^I change numeric value for variable field measurement to "([^"]*)"$/) do  |new_value|
  fill_in 'Numeric value', with: new_value
end