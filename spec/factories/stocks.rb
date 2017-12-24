# frozen_string_literal: true

# == Schema Information
#
# Table name: stocks
#
#  id         :integer          not null, primary key
#  article_id :string(128)      not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :stock
end
