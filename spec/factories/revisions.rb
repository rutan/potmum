# == Schema Information
#
# Table name: revisions
#
#  id         :integer          not null, primary key
#  article_id :string(128)
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :revision do
    body { Faker::Lorem.paragraph }
  end
end
