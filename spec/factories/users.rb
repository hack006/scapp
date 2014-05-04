# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    locale
    password 'changeme'
    password_confirmation 'changeme'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now

    factory :player do
      after(:create) {|user| user.add_role(:player)}
    end

    factory :coach do
      after(:create) {|user| user.add_role(:coach)}
    end

    factory :admin do
      after(:create) {|user| user.add_role(:admin)}
    end
  end
end
