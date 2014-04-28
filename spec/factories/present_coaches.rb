# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :present_coach do
    salary_without_tax 1.5
    vat nil
    currency nil
    user nil
    training_lesson_realization nil
    supplementation false
  end
end
