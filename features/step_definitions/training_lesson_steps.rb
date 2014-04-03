And(/^Following regular training lessons exist in the system$/) do |table|
  # table is a table.hashes.keys # => [:day, :odd, :even, :from, :until, :regular_training, :player_price_wt, :group_price_wt, :training_vat, :currency, :rental_price_wt, :rental_vat, :calculation]
  table.hashes.each do |l|
    regular_training = RegularTraining.friendly.find(l[:regular_training])
    training_vat = Vat.friendly.find(l[:training_vat])
    rental_vat = Vat.friendly.find(l[:rental_vat])
    currency = Currency.friendly.find(l[:currency])

    TrainingLesson.create(day: l[:day].to_sym, odd_week: l[:odd], even_week: l[:even], from: l[:from], until: l[:until],
                          regular_training: regular_training, player_price_without_tax: l[:player_price_wt],
                          group_price_without_tax: l[:group_price_wt], training_vat: training_vat, currency: currency,
                          rental_price_without_tax: l[:rental_price_wt], rental_vat: rental_vat, calculation: l[:calculation].to_sym)
  end
end

When(/^I fill in all necessary training lesson fields$/) do |table|
  # table is a table.hashes.keys # => [:day, :odd, :even, :from, :until, :player_price_wt, :group_price_wt, :training_vat, :currency, :rental_price_wt, :rental_vat, :calculation]
  f = table.hashes.first

  select f[:day], from: 'Day'
  check 'Odd week' if f[:odd]
  uncheck 'Odd week' unless f[:odd]
  check 'Even week' if f[:even]
  uncheck 'Even week' unless f[:even_week]
  fill_in 'training_lesson_from', with: f[:from]
  fill_in 'training_lesson_until', with: f[:until]
  fill_in 'Player price without VAT', with: f[:player_price_wt]
  fill_in 'Group price without VAT', with: f[:group_price_wt]
  fill_in 'Rental price without VAT', with: f[:rental_price_wt]
  select f[:currency], from: 'Currency'
  select f[:training_vat], from: 'Training VAT'
  select f[:rental_vat], from: 'Rental VAT'
  choose f[:calculation]

end

And(/^I should see "([^"]*)" in the date & time table$/) do |text|
  within find('#tl-date-time table.table') do
    page.should have_content text
  end
end

And(/^I should see "([^"]*)" in the finance table$/) do |text|
  within find('#tl-finance table') do
    page.should have_content text
  end
end