# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  name        :string(32)       not null
#  email       :string
#  stock_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  role        :integer          default(0)
#

FactoryGirl.define do
  factory :user do
    name { Faker::Lorem.characters(8) }

    factory :user_with_email do
      email { Faker::Internet.email }
    end
  end
end
