And(/^Following regular training lesson realizations exist$/) do |table|
  # table is a table.hashes.keys # => [:regular_training, :day, :from, :until, :date, :status, :note, :sign_in_time, :excuse_time]
  table.hashes.each do |row|
    regular_training = RegularTraining.friendly.find(row[:regular_training])
    tl = regular_training.training_lessons.where(from: row[:from], until: row[:until]).first
    RegularTrainingLessonRealization.create(date: row[:date], status: row[:status], note: row[:note], training_lesson: tl,
                                            sign_in_time: row[:sign_in_time], excuse_time: row[:excuse_time], calculation: tl.calculation,
                                            group_price_without_tax: tl.group_price_without_tax, player_price_without_tax: tl.player_price_without_tax,
                                            rental_price_without_tax: tl[:rental_price_without_tax], training_vat: tl.training_vat,
                                            rental_vat: tl.rental_vat)
  end
end

And(/^Following individual training lesson realizations exist$/) do |table|
  # table is a table.hashes.keys # => [:owner, :date:from, :until, :player_price_wt, :group_price_wt, :training_vat, :currency, :rental_price_wt, :rental_vat, :calculation, :status, :note, :sign_in_time, :excuse_time, :is_open, :player_count_limit]
  table.hashes.each do |row|
    owner = User.friendly.find(row[:owner])
    training_vat = Vat.friendly.find(row[:training_vat])
    rental_vat = Vat.friendly.find(row[:rental_vat])
    currency = Currency.friendly.find(row[:currency])
    IndividualTrainingLessonRealization.create(user: owner,
                                               date: row[:date],
                                               from: row[:from],
                                               until: row[:until],
                                               sign_in_time: row[:sign_in_time],
                                               excuse_time: row[:excuse_time],
                                               calculation: row[:calculation],
                                               group_price_without_tax: row[:group_price_wt],
                                               player_price_without_tax: row[:player_price_wt],
                                               rental_price_without_tax: row[:rental_price_wt],
                                               training_vat: training_vat,
                                               rental_vat: rental_vat,
                                               currency: currency,
                                               status: row[:status],
                                               note: row[:note],
                                               is_open: row[:is_open],
                                               player_count_limit: row[:player_count_limit])
  end
end

And(/^I should see "([^"]*)" in registered players$/) do |player|
  within find('#tlr-players table') do
    page.should have_content(player)
  end
end


And(/^I shouldn't see prices for "([^"]*)" in the registered players table$/) do |player|
  within find('#tlr-players table') do
    find(:xpath, "//table//tr[contains(./td, '#{player}')]").should_not have_content(I18n.t('dictionary.vat_included'))
  end
end

And(/^I shouldn't see prices for "([^"]*)" in the registered coaches table$/) do |coach|
  within find('#tlr-coaches table') do
    find(:xpath, "//table//tr[contains(./td, '#{coach}')]").should_not have_content(I18n.t('dictionary.vat_included'))
  end
end

And(/^I should see "([^"]*)" in registered coaches$/) do |coach|
  within find('#tlr-coaches table') do
    page.should have_content(coach)
  end
end

And(/^I shouldn't see "([^"]*)" in registered coaches$/) do |coach|
  within find('#tlr-coaches table') do
    page.should_not have_content(coach)
  end
end

When(/^I fill all all required fields for regular training lesson realization$/) do |table|
  # table is a table.hashes.keys # => [:sign_in_limit, :excuse_limit, :calculation, :player_price_without_vat, :group_price_without_vat, :training_vat, :rental_price_without_vat, :rental_vat, :note]
  tl = table.hashes.first

  select tl[:calculation], from: 'regular_training_lesson_realization_calculation'
  fill_in 'regular_training_lesson_realization_sign_in_time', with: tl[:sign_in_limit]
  fill_in 'regular_training_lesson_realization_excuse_time', with: tl[:excuse_limit]
  fill_in 'Player price without VAT', with: tl[:player_price_without_vat]
  fill_in 'Group price without VAT', with: tl[:group_price_without_vat]
  fill_in 'Rental price without VAT', with: tl[:rental_price_without_vat]
  select tl[:training_vat], from: 'regular_training_lesson_realization_training_vat_id'
  select tl[:rental_vat], from: 'regular_training_lesson_realization_rental_vat_id'
  fill_in 'Note', with: tl[:note]
end

And(/^I should see "([^"]*)" for "([^"]*)" in scheduled lesson details$/) do |value, name|
  within find('#tlr-detail') do
    find(:xpath, "//tr[th[contains(text(), '#{name}')]]").should have_content value
  end
end

And(/^I should see "([^"]*)" in training realization note$/) do |note|
  find('#lesson-realization-note').should have_content note
end

When(/^I fill all required fields for individual training lesson$/) do |table|
  # table is a table.hashes.keys # => [:date, :from, :until, :sign_in_limit, :excuse_limit, :calculation, :currency, :player_price_without_vat, :group_price_without_vat, :training_vat, :rental_price_without_vat, :rental_vat, :can_sign_in, :max_players, :note]

  tl = table.hashes.first

  # date & time
  fill_in 'individual_training_lesson_realization_date', with: tl[:date]
  fill_in 'individual_training_lesson_realization_from', with: tl[:from]
  fill_in 'individual_training_lesson_realization_until', with: tl[:until]
  fill_in 'individual_training_lesson_realization_sign_in_time', with: tl[:sign_in_limit]
  fill_in 'individual_training_lesson_realization_excuse_time', with: tl[:excuse_limit]
  # finance
  select tl[:calculation], from: 'individual_training_lesson_realization_calculation'
  select tl[:currency], from: 'individual_training_lesson_realization_currency_id'
  fill_in 'Player price without VAT', with: tl[:player_price_without_vat]
  fill_in 'Group price without VAT', with: tl[:group_price_without_vat]
  fill_in 'Rental price without VAT', with: tl[:rental_price_without_vat]
  select tl[:training_vat], from: 'individual_training_lesson_realization_training_vat_id'
  select tl[:rental_vat], from: 'individual_training_lesson_realization_rental_vat_id'
  # other
  fill_in 'Note', with: tl[:note]
  if tl[:can_sign_in]
    check 'individual_training_lesson_realization_is_open'
  else
    uncheck 'individual_training_lesson_realization_is_open'
  end
  fill_in 'individual_training_lesson_realization_player_count_limit', with: tl[:max_players]

end

Then(/^I should see "([^"]*)" in the open trainings$/) do |text|
  within find('#trainings-open table') do
    page.should have_content text
  end
end

And(/^I should see calculated price without vat "([^"]*)" for player "([^"]*)" in registered players table$/) do |price_wt, player|
  within find('#tlr-players table') do
    find(:xpath, "//tr[td[contains(., '#{player}')]]").text.should have_content price_wt
  end
end

And(/^I shouldn't see player "([^"]*)" in the registered players listing$/) do |player|
  within find('#tlr-players table') do
    page.should_not have_content player
  end
end