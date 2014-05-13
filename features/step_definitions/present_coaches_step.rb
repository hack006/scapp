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