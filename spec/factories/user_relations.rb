# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_relation do
    relation "MyString"
    from_user_status "MyString"
    to_user_status "MyString"
  end
end
