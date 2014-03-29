# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :training_lesson do
    description "MyString"
    day "MyString"
    from "2014-03-29 08:34:57"
    self.until "2014-03-29 08:34:57"
    calculation "MyString"
    from_date "2014-03-29 08:34:57"
    until_date "2014-03-29 08:34:57"
    player_price_without_tax 1.5
    group_price_without_tax 1.5
    rental_price_without_tax 1.5
    training_vat nil
    rental_vat ""
    regular_training nil
  end
end
