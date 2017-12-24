# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id                 :string(128)      not null, primary key
#  user_id            :integer
#  title              :string(128)
#  newest_revision_id :integer
#  view_count         :integer          default(0), not null
#  stock_count        :integer          default(0), not null
#  comment_count      :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  published_at       :datetime
#  publish_type       :integer          default("draft_item")
#  like_count         :integer          default(0)
#

FactoryBot.define do
  factory :article do
    user { create(:user) }
    title { Faker.name }
    newest_revision { create(:revision) }

    factory :article_with_published_at do
      publish_type 2
      published_at Time.zone.now
    end

    trait :public_item do
      publish_type 2
      published_at Time.zone.now
    end

    trait :private_item do
      publish_type 1
      published_at Time.zone.now
    end

    trait :draft do
      publish_type 0
    end
  end
end
