# frozen_string_literal: true
# == Schema Information
#
# Table name: revisions
#
#  id            :integer          not null, primary key
#  article_id    :string(128)
#  body          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  title         :string           default("")
#  tags_text     :text             default("")
#  user_id       :integer
#  published_at  :datetime
#  revision_type :integer          default(0)
#  note          :text
#

FactoryGirl.define do
  factory :revision do
    user { create(:user) }
    title { Faker.name }
    body { Faker::Lorem.paragraph }
    note { Faker::Lorem.sentence }
    tags_text { Faker::Lorem.words.join(' ') }
    revision_type 2
  end
end
