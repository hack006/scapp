And(/^Following VF categories exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:user, :name, :description, :RGB, :is_global]
  table.hashes.each do |vfc|
    user = User.friendly.find(vfc[:user])

    VariableFieldCategory.create(name: vfc[:name], description: vfc[:description], rgb: vfc[:rgb],
                                 is_global: vfc[:is_global], user: user)
  end
end

When(/^I view detail page of "([^"]*)" vfc$/) do |category|
  vfc = VariableFieldCategory.where(name: category).first

  visit "/variable_field_categories/#{vfc.id}"
end

When(/^I view edit page of "([^"]*)" vfc$/) do |category|
  vfc = VariableFieldCategory.where(name: category).first

  visit "/variable_field_categories/#{vfc.id}/edit"
end

When(/^I fill in all required VF category details$/) do |table|
  # table is a table.hashes.keys # => [:name, :rgb, :description, :is_global, :user]
  vfc = table.hashes.first

  fill_in 'variable_field_category_name', with: vfc[:name]
  fill_in 'variable_field_category_rgb', with: vfc[:rgb]
  fill_in 'variable_field_category_description', with: vfc[:description]

  check 'variable_field_category_is_global' if vfc[:is_global] == "true"
  select vfc[:user], from: 'variable_field_category_user_id' unless vfc[:user].blank?
end