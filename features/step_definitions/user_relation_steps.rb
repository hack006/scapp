And(/^I have "([^"]*)" relation with user "([^"]*)"$/) do |relation, user_name|
  user2 = User.where(name: user_name).first
  UserRelation.add_relation @user, user2, 'coach', 'accepted', 'accepted'
end