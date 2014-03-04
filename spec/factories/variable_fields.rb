# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :variable_field do
    name "MyVariableField"
    description "MyDescription"
    unit "unit"
    higher_is_better true
    is_numeric true
    is_global true
    user nil
    variable_field_category nil
  end
end
