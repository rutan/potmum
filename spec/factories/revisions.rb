FactoryGirl.define do
  factory :revision do
    body { Faker::Lorem.paragraph }
  end
end
