# frozen_string_literal: true

# == Schema Information
#
# Table name: attachment_files
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  file       :string(128)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :attachment_file do
    user nil
    file 'MyString'
  end
end
