# frozen_string_literal: true

# == Schema Information
#
# Table name: likes
#
#  id          :integer          not null, primary key
#  target_type :string           not null
#  target_id   :string           not null
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :like do
    target { create(:article, :public_item) }
    user { create(:user) }
  end
end
