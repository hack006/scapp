# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :variable_field_category do
    name "Example"
    rgb "#123456"
    description "Example category with text"
    user nil
  end
end
