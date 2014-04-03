And(/^Following coach obligations exist$/) do |table|
  # table is a table.hashes.keys # => [:regular_training, :user, :hourly_wage_wt, :vat, :currency, :coach_role]
  table.hashes.each do |o|
    regular_training = RegularTraining.friendly.find(o[:regular_training])
    user = User.friendly.find(o[:user])
    vat = Vat.friendly.find(o[:vat])
    currency = Currency.friendly.find(o[:currency])

    CoachObligation.create(user: user, coach_email: user.email, regular_training: regular_training, hourly_wage_without_vat: o[:hourly_wage_wt],
                           vat: vat, currency: currency, role: o[:coach_role].to_sym)
  end
end

When(/^I fill in all fields to change coach obligation fields$/) do |table|
  # table is a table.hashes.keys # => [:hourly_wage_wt, :vat, :currency, :coach_role]
  f = table.hashes.first
  fill_in 'Hour wage without VAT', with: f[:hourly_wage_wt]
  select f[:vat], from: 'VAT'
  select f[:currency], from: 'Currency'
  select f[:coach_role], from: 'Role'
end

When(/^I fill in all necessary coach obligation fields$/) do |table|
  # table is a table.hashes.keys # => [:coach_email, :hourly_wage_wt, :vat, :currency, :coach_role]
  f = table.hashes.first
  fill_in 'Coach email', with: f[:coach_email]
  fill_in 'Hour wage without VAT', with: f[:hourly_wage_wt]
  select f[:vat], from: 'VAT'
  select f[:currency], from: 'Currency'
  select f[:coach_role], from: 'Role'
end