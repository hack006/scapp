And(/^Following attendance entries exists$/) do |table|
  # table is a table.hashes.keys # => [:user, :training_realization, :participation, :price_without_tax, :note, :excuse_reason]
  table.hashes.each do |r|
    user = User.friendly.find(r[:user])
    tlr = TrainingLessonRealization.friendly.find(r[:training_realization])

    Attendance.create(user: user, user_email: user.email, training_lesson_realization: tlr, participation: r[:participation],
                      price_without_tax: r[:price_without_tax], note: r[:note], excuse_reason: r[:excuse_reason])
  end
end

When(/^I check "([^"]*)" attendance for "([^"]*)" player on "([^"]*)" scheduled lesson$/) do |participation, player, scheduled_lesson|
  user = User.friendly.find(player)
  training_lesson_realization = TrainingLessonRealization.friendly.find(scheduled_lesson)
  attendance_entry = Attendance.where(user: user, training_lesson_realization: training_lesson_realization).first

  choose "attendances_#{attendance_entry.id}_status_#{participation}"
end

Then(/^I should see calculated price without vat "([^"]*)" for player "([^"]*)"$/) do |price_wt, player|
  within find('table#attendance-player-payments') do
    find(:xpath, "//tr[td[contains(., '#{player}')]]//input[contains(@class, 'price-without-vat')]").value.should have_content price_wt
  end
end

When(/^I change attendance price without vat for "([^"]*)" player to "([^"]*)" value$/) do |player, price_wt|
  within find('table#attendance-player-payments') do
    find(:xpath, "//tr[td[contains(., '#{player}')]]//input[contains(@class, 'price-without-vat')]").set price_wt
  end
end

And(/^I should see "([^"]*)" in the player attendance summary list$/) do |text|
  within find('#rt-player-attendance-summary') do
    page.should have_content text
  end
end

And(/^Player attendance statistics should have variable "([^"]*)" with containing value "([^"]*)"$/) do |variable, value|
  within find('#rt-player-attendance-stats') do
    find(:xpath, "//table//tr[contains(./td, '#{variable}')]").should have_content value
  end
end

And(/^I should see following training states "([^"]*)" for user "([^"]*)"$/) do |states_str, user|
  states = states_str.split(',')
  within find('#players-training-attendance') do
    states.each_with_index do |participation_state, index|
      find(:xpath, "//table//tr[contains(./td, '#{user}')]//td[#{index + 2}]").should have_content participation_state
    end
  end
end

When(/^I fill in "([^"]*)" user email field into attendance from$/) do |email|
  fill_in 'attendance_user_email', with: email
end