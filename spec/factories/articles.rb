FactoryGirl.define do
  factory :article do
    user { create(:user) }
    title { Faker.name }
    newest_revision { create(:revision) }

    factory :article_with_published_at do
      published_at Time.zone.now
    end
  end
end
