# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :variable_field_optimal_value do
    bottom_limit 1.5
    upper_limit 1.5
    source "MyString"
    variable_field nil
    variable_field_sport nil
    variable_field_user_level "MyString"
  end
end
