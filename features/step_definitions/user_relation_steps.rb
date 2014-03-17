And(/^I have "([^"]*)" relation with user "([^"]*)"$/) do |relation, user_name|
  user2 = User.where(name: user_name).first
  UserRelation.add_relation @user[1], user2, relation, 'accepted', 'accepted'
end

And(/^I should see coach with name "([^"]*)"$/) do |coach_name|
  found = false
  all(:css, '.box.coach h3.box-title').each do |c|
    if c.has_text? coach_name
      found = true
      break
    end
  end

  found.should be_true
end

And(/^I shouldn't see coach with name "([^"]*)"$/) do |coach_name|
  found = false
  all(:css, '.box.coach h3.box-title').each do |c|
    if c.has_text? coach_name
      found = true
      break
    end
  end

  found.should be_false
end

And(/^"([^"]*)" has "([^"]*)" relation with user "([^"]*)"$/) do |user_from, relation, user_to|
  from = User.friendly.find(user_from)
  to = User.friendly.find(user_to)

  UserRelation.add_relation(from, to, relation, 'accepted', 'accepted')
end