require_relative 'utility_methods'

def find_or_create_category(name)
  @category ||= VariableFieldCategory.where(name: name).first
  unless @category
    @category = FactoryGirl.create(:variable_field_category, {name: name})
    @category.save!
  end
end

def find_or_create_category_with_user(name, description, user_id)
  c ||= VariableFieldCategory.where(name: name, user_id: user_id ).first
  unless c
    c = VariableFieldCategory.create!(name: name, description: description)
    c.user_id = user_id
    c.save
  end
end

Given(/^I am on the variable_field add new page$/) do
  visit '/variable_fields/new'
end


And(/^I have "(.*?)" role$/) do |arg1|
  @user.add_role arg1
end

And(/^category "(.*?)" exists$/) do |arg1|
  find_or_create_category(arg1)
  VariableFieldCategory.where(name: arg1).any?
end

When(/^I fill in all necessary fields$/) do |table|
  # table is a Cucumber::Ast::Table
  table_hash = table.hashes.first
  fill_in 'variable_field_name', with: table_hash['name']
  fill_in 'variable_field_description', with: table_hash['description']
  fill_in 'variable_field_unit', with: table_hash['unit']
  if table_hash['higher_is_better'] == true
    check 'variable_field_higher_is_better'
  else
    uncheck 'variable_field_higher_is_better'
  end
  if table_hash['is_numeric'] == true
    check 'variable_field_is_numeric'
  else
    uncheck 'variable_field_is_numeric'
  end
end

And(/^I select "(.*?)" category$/) do |arg1|
  select arg1, from: 'variable_field_variable_field_category_id'
end

And(/^I send form$/) do
  click_link_or_button 'Save'
end

Then(/^I should see an successfully created message$/) do
  page.should have_content "Variable field was successfully created."
end

When(/^another user owning category exists$/) do
  create_user2
end

When(/^following categories are available in the system$/) do |table|
  # table is a | Strength  | Strength desc | nil       |
  find_or_create_category_with_user(table.hashes[0]['name'], table.hashes[0]['description'], nil)
  find_or_create_category_with_user(table.hashes[1]['name'], table.hashes[1]['description'], @user.id)
  find_or_create_category_with_user(table.hashes[2]['name'], table.hashes[2]['description'], @user2.id)
end
Then(/^As user with username "([^"]*)" I should see "([^"]*)" and "([^"]*)" but not "([^"]*)"$/) do |arg1, arg2, arg3, arg4|
      should have_content arg2
      should have_content arg3
      should_not have_content arg4
end
Given(/^category "([^"]*)" doesn't exist in my scope \(user, public\)$/) do |arg|
  vfcs = VariableFieldCategory.where(name: arg, user_id: [@user.id, nil])
  vfcs.each{|vfc| vfc.destroy}

  # add another username category with same name
  vfc = VariableFieldCategory.create(name: "intelligence", description: "int. desc.")
  create_user2
  vfc.user = @user2
  vfc.save
end
Then(/^I shouldn't see "([^"]*)" category in the list$/) do |arg|
  within(:css, 'select#variable_field_variable_field_category_id') do
    page.should_not have_content arg
  end
end
Then(/^I should see "([^"]*)" category selected$/) do |arg|
  page.has_select?("variable_field_variable_field_category_id", :selected => arg).should == true
end
When(/^category "([^"]*)" should exist in db with my username$/) do |arg|
  VariableFieldCategory.where(name: arg, user_id: @user.id).count.should  eq(1)
end
When(/^I add category named "([^"]*)"$/) do |arg|
  fill_in 'variable_field_category_name', with: arg
  click_link_or_button 'Add'
end
When(/^I select option add category$/) do
  click_link_or_button 'Add category'
end
When(/^Following variable fields exist in system$/) do |table|
  # table is a | IQ          | inteligence quoc.   | intelligence | test1     |
  table.hashes.each do |r|
    # get user
    owner = User.where(name: r[:user]).first
    # get category
    category = VariableFieldCategory.where(name: r[:category]).first
    # create variable field
    var_field = VariableField.new(name: r[:name], description: r[:description])
    var_field.variable_field_category = category
    var_field.user = owner
    var_field.save
  end
end
When(/^I am on the variable fields index page$/) do
  visit variable_fields_path
end
Then(/^I should see following names in the table$/) do |table|
  table.raw.flatten.each do |c|
    within("table") do
      page.should have_content c
    end
    end
end
When(/^I shouldn't see following names in the table$/) do |table|
  table.raw.flatten.each do |c|
    within("table") do
      page.should_not have_content c
    end
  end
end
Given(/^I am at the "([^"]*)" page$/) do |page|
  visit page
end
When(/^confirm dialog$/) do
  page.driver.browser.switch_to.alert.accept
end
Then(/^I shouldn't see "([^"]*)" in the table$/) do |text|
  within(:css, "table") do
    page.should_not have_content text
  end
end
When(/^I click "([^"]*)" for "([^"]*)" in table row$/) do |action_text, name|
  find(:xpath, "//tr[td[contains(.,'#{name}')]]/td/a", :text => action_text).click
end
When(/^variable_fields exists$/) do |table|
  # table is a | IQ                | test1     | intelligence  |

  # We assume that user and category exist
  table.hashes.each do |r|
    u = User.where(name: r[:owner]).first
    c = VariableFieldCategory.where(name: r[:category]).first
    vf = VariableField.new(name: r[:variable_field_name])
    vf.user = u
    vf.variable_field_category = c
    vf.save
  end
end
When(/^variable_field_measurements exists for "([^"]*)" of owner "([^"]*)"$/) do |name, owner, table|
  # table is a | test1   | 120           |

  # We assume that user and variable field exists
  table.hashes.each do |r|
    u = User.where(name: r[:owner]).first
    vf = VariableField.where(name: name).first
    vfm = VariableFieldMeasurement.new(int_value: r[:int_value])
    vfm.measured_by = u
    vfm.measured_for = u
    vfm.variable_field = vf
    vfm.save
  end
end
Then(/^I should we warned that measurements exists and variable_field can't be removed$/) do
  page.should have_content "field can't be deleted"
end
Then(/^I should see "([^"]*)" containing "([^"]*)"$/) do |element, text|
  case element
    when "heading"
      find(:css, "h1,h2,h3,h4,h5").should have_text text
    when "paragraph"
      find(:css, "p").should have_text text
    when "alert message"
      find(:css, "div.alert").should have_text text
    when "error message"
      find(:css, "div.alert-danger").should have_text text
    when "warning message"
      find(:css, "div.alert-warning").should have_text text
    when "info  message"
      find(:css, "div.alert-info").should have_text text
    when "success message"
      find(:css, "div.alert-success").should have_text text

  end

end
When(/^I edit variable field$/) do
  fill_in 'variable_field_name', with: "changed name"
end
When(/^I fill in correct modification confirmation token$/) do
  modification_token = find(:css, "div.alert.alert-warning").text[/[0-9]*$/]
  fill_in "variable_field_modification_confirmation", with: modification_token
end