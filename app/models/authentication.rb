# frozen_string_literal: true
# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(32)       not null
#  uid        :string(128)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Authentication < ActiveRecord::Base
  belongs_to :user
end
