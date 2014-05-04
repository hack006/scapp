And(/^I have "([^"]*)" relation with user "([^"]*)"$/) do |relation, user_name|
  user2 = User.where(name: user_name).first
  UserRelation.add_relation @user[1], user2, relation, 'accepted', 'accepted'
end

And(/^I should see coach with name "([^"]*)"$/) do |coach_name|
  within find("#connected-coaches table") do
    page.should have_content coach_name
  end
end

And(/^I shouldn't see coach with name "([^"]*)"$/) do |coach_name|
  within find("#connected-coaches table") do
    page.should_not have_content coach_name
  end
end

And(/^"([^"]*)" has "([^"]*)" relation with user "([^"]*)"$/) do |user_from, relation, user_to|
  from = User.friendly.find(user_from)
  to = User.friendly.find(user_to)

  UserRelation.add_relation(from, to, relation, 'accepted', 'accepted')
end

And(/^"([^"]*)" has "([^"]*)" relation with me$/) do |user_from, relation|
  from = User.friendly.find(user_from)
  to = @user[1]

  UserRelation.add_relation(from, to, relation, 'accepted', 'accepted')
end

And(/^"([^"]*)" has "([^"]*)" "([^"]*)" relation with "([^"]*)"$/) do |user_from, relation_status, relation, user_to|
  user_from = User.where(name: user_from).first
  user_to = User.where(name: user_to).first

  UserRelation.add_relation user_from, user_to, relation, relation_status, relation_status
end

When(/^I fill in all necessary relation fields$/) do |table|
  # table is a table.hashes.keys # => [:to_user_mail, :relation_type]
  fill_in 'Email address of user', with: table.hashes.first[:to_user_mail]
  case table.hashes.first[:relation_type]
    when 'friend'
      choose 'I want to be FRIEND of selected user'
    when 'coach'
      choose 'I want to be COACH of selected user'
    when 'watcher'
      choose 'I want to be WATCHER of selected user'
  end
end

When(/^I fill in all necessary user relations \(all\) fields$/) do |table|
  # table is a table.hashes.keys # => [:relation, :from_user_mail, :to_user_mail, :from_user_status, :to_user_status]
  f = table.hashes.first

  fill_in 'user_relation_first_user', with: f[:from_user_mail]
  fill_in 'user_relation_second_user', with: f[:to_user_mail]
  choose "user_relation_from_user_status_#{f[:from_user_status]}"
  choose "user_relation_to_user_status_#{f[:to_user_status]}"
  choose "user_relation_relation_#{f[:relation]}"
end