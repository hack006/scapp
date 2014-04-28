# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attendance do
    participation "MyString"
    price_without_tax 1.5
    player_change "2014-04-06 20:03:21"
    training_lesson_realization nil
    user nil
    payment nil
  end
end
