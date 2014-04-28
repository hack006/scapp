# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    amount 1.5
    status "MyString"
    currency nil
    received_by nil
  end
end
