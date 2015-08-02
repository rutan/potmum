FactoryGirl.define do
  factory :user do
    name { Faker::Lorem.characters(8) }

    factory :user_with_email do
      email { Faker::Internet.email }
    end
  end
end
