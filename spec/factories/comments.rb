FactoryGirl.define do
  factory :comment do
    user { create(:user) }
    body { Faker::Lorem.paragraph }

    factory :comment_with_article do
      article { create(:article_with_published_at) }
    end
  end
end
