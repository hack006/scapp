# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coach_obligation do
    role "MyString"
    hourly_wage_without_vat 1.5
    references ""
    references ""
    references ""
  end
end
