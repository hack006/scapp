And(/^Following groups exists in the system$/) do |table|
  # table is a table.hashes.keys # => [:name, :description, :long desc, :owner, :visibility, :is_global]
  table.hashes.each do |r|
    user = User.friendly.find(r[:owner])
    UserGroup.create({ name: r[:name], description: r[:description], long_description: r[:long_description],
                     owner: user, visibility: r[:visibility], is_global: r[:is_global]})
  end
end

And(/^User "([^"]*)" is in group "([^"]*)"$/) do |user, group|
  g = UserGroup.where(name: group).first
  u = User.friendly.find(user)
  g.users << u
  u.save
end

When(/^I fill in all necessary user group fields$/) do |table|
  # table is a table.hashes.keys # => [:name, :description, :long desc, :owner, :visibility]
  f = table.hashes.first

  fill_in 'Name', with: f[:name]
  fill_in 'Description', with: f[:description]
  fill_in 'Long description', with: f[:long_description]
  choose f[:visibility]
end

When(/^I click add New group action button$/) do
  within find('#action-box') do
    click_link_or_button 'New group'
  end
end

And(/^I should see "([^"]*)" in user group members table$/) do |user_name|
  within(:css, "#group-members.box-info table") do
    page.should have_content user_name
  end
end

And(/^I shouldn't see "([^"]*)" in user group members table$/) do |user_name|
  within(:css, "#group-members.box-info table") do
    page.should_not have_content user_name
  end
end

When(/^I fill in email "([^"]*)" for adding new user$/) do |email|
  fill_in 'Email', with: email
end