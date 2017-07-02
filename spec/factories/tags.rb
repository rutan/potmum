# frozen_string_literal: true
# == Schema Information
#
# Table name: tags
#
#  id            :integer          not null, primary key
#  name          :string(64)       not null
#  content       :string(64)       not null
#  article_count :integer          default(0), not null
#  is_menu       :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  key           :string(128)
#

FactoryGirl.define do
  factory :tag do
    content { Faker::Name.first_name }
    article_count 0
    is_menu false
    key { SecureRandom.hex.remove('-') }
  end
end
