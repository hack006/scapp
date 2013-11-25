# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :variable_field do
    name "MyString"
    description "MyString"
    unit "MyString"
    higher_is_better false
    is_numeric false
    user nil
    variable_field_category nil
  end
end
