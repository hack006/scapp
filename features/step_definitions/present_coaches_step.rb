And(/^Following present coaches exists$/) do |table|
  # table is a table.hashes.keys # => [:training_lesson_realization, :user, :vat, :currency, :salary_without_tax, :supplementation]
  table.hashes.each do |r|
    user = User.friendly.find(r[:user])
    tlr = TrainingLessonRealization.friendly.find(r[:training_lesson_realization])
    vat = Vat.friendly.find(r[:vat])
    currency = Currency.friendly.find(r[:currency])

    PresentCoach.create(user: user, user_email: user.email, vat: vat, currency: currency, training_lesson_realization: tlr,
                        salary_without_tax: r[:salary_without_tax], supplementation: r[:supplementation])
  end
end

When(/^I fill all required fields for present coach$/) do |table|
  # table is a table.hashes.keys # => [:email, :salary_wt, :vat, :currency]
  pc = table.hashes.first

  fill_in 'Coach email', with: pc[:email] unless pc[:email].nil?
  fill_in 'Salary without tax', with: pc[:salary_wt]
  select pc[:vat], from: 'present_coach_vat_id'
  select pc[:currency], from: 'present_coach_currency_id'

  if pc[:supplementation] == true
    check 'Supplementation'
  else
    uncheck 'Supplementation'
  end

end