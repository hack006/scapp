# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :variable_field_category do
    name "MyString"
    rgb "MyString"
    description "MyString"
    user nil
  end
end
