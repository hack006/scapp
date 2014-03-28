# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vat do
    name "MyString"
    percentage_value 1.5
    is_time_limited false
    start_of_validity "2014-03-28 10:50:05"
    end_of_validity "2014-03-28 10:50:05"
  end
end
