# frozen_string_literal: true

# == Schema Information
#
# Table name: api_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token_type :integer
#  title      :string(32)
#  token      :string(128)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :access_token do
    user { create(:user) }
    token_type 1
    permit_type 1
    title { Faker.name }
    token { SecureRandom.hex(32) }

    trait :system do
      token_type 0
      permit_type 1
    end

    trait :readable do
      token_type 1
      permit_type 0
    end

    trait :writable do
      token_type 1
      permit_type 1
    end
  end
end
