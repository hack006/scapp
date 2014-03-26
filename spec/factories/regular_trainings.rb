# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :regular_training do
    name "MyString"
    description "MyText"
    public false
    user nil
  end
end
