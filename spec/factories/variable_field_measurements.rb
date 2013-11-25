# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :variable_field_measurement do
    measured_at "2013-11-25 10:59:21"
    locality "MyString"
    string_value "MyString"
    int_value 1.5
  end
end
