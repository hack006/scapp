# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :training_lesson_realization do
    date "2014-04-03"
    from "2014-04-03 23:52:09"
    self.until "2014-04-03 23:52:09"
    player_price_without_tax 1.5
    group_price_without_tax 1.5
    rental_price_without_tax 1.5
    calculation "MyString"
    status "MyString"
    note "MyText"
    training_vat nil
    rental_vat nil
    currency nil
    training_lesson nil
    user nil
  end
end
