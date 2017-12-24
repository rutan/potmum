# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  article_id :string(128)      not null
#  user_id    :integer
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  key        :string(128)
#

FactoryBot.define do
  factory :comment do
    article { create(:article, :public_item) }
    user { create(:user) }
    body { Faker::Lorem.paragraph }
    key { SecureRandom.hex.remove('-') }

    factory :comment_with_article do
      article { create(:article_with_published_at) }
    end
  end
end
