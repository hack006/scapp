require_relative 'utility_methods'

def find_or_create_category(name)
  @category ||= VariableFieldCategory.where(name: name).first
  unless @category
    @category = FactoryGirl.create(:variable_field_category, {name: name})
    @category.save!
  end
end

Given(/^I am on the variable_field add new page$/) do
  visit '/variable_fields/new'
end


And(/^I have "(.*?)" role$/) do |arg1|
  @user.add_role arg1.to_sym
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
  # table is a | name | description | is_global | user |
  # TODO: fix to take values from table
  table.hashes.each do |r|
    user = User.where(name: r[:user]).first

    # test if exist
    unless VariableFieldCategory.where(name: r[:name], user_id: user).count > 0
      FactoryGirl.create :variable_field_category, { name: r[:name], description: r[:description],
                                                     is_global: r[:is_global], user: user }
    end
  end
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
  #  | name | description | is_global | is_numeric | category | user |

  table.hashes.each do |r|
    # get user
    user = User.where(name: r[:user]).first
    # get category
    category = VariableFieldCategory.where(name: r[:category]).first
    # create variable field
    unless VariableField.where(name: r[:name], is_global: false, user_id: user).count > 0 ||
           VariableField.where(name: r[:name], is_global: true).count > 0

      FactoryGirl.create :variable_field, { name: r[:name], description: r[:description], is_global: r[:is_global],
                                            is_numeric: r[:is_numeric], variable_field_category: category, user: user}
    end
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
  found  = false
  case element
    when "heading"
      found = exists_element_with_text? "h1,h2,h3,h4,h5,h6,h7", text
    when "paragraph"
      found = exists_element_with_text? "p", text
    when "alert message"
      found = exists_element_with_text? "div.alert", text
    when "error message"
      found = exists_element_with_text? "div.alert-danger", text
    when "warning message"
      found = exists_element_with_text? "div.alert-warning", text
    when "info  message"
      found = exists_element_with_text? "div.alert-info", text
    when "success message"
      found = exists_element_with_text? "div.alert-success", text

  end

  raise Exception, "Element: '#{element}' with text: '#{text}' wasn't found!" unless found
end

def exists_element_with_text?(selector, text)
  found = false
  all(:css, selector).each do |h|
    if h.has_text? text
      found = true
      break
    end
  end

  found
end

Then(/^I shouldn't see "([^"]*)" containing "([^"]*)"$/) do |element, text|
  found  = false
  case element
    when "heading"
      found = exists_element_with_text? "h1,h2,h3,h4,h5,h6,h7", text
    when "paragraph"
      found = exists_element_with_text? "p", text
    when "alert message"
      found = exists_element_with_text? "div.alert", text
    when "error message"
      found = exists_element_with_text? "div.alert-danger", text
    when "warning message"
      found = exists_element_with_text? "div.alert-warning", text
    when "info  message"
      found = exists_element_with_text? "div.alert-info", text
    when "success message"
      found = exists_element_with_text? "div.alert-success", text

  end

  found ? false : true
end
When(/^I edit variable field$/) do
  fill_in 'variable_field_name', with: "changed name"
end
When(/^I fill in correct modification confirmation token$/) do
  modification_token = find(:css, "div.alert.alert-warning").text[/[0-9]*$/]
  fill_in "variable_field_modification_confirmation", with: modification_token
end
When(/^I visit variable_field view results page of "([^"]*)"$/) do |user_slug|
  visit user_variable_fields_path(user_slug)
end
When(/^"([^"]*)" "([^"]*)" value should be "([^"]*)"$/) do |box, type, value|
  container = ".vf-name-#{box} .#{type}-value-box"
  find(:css, container).find(:css, '.bigger').should have_content value
end