# == Schema Information
#
# Table name: access_tokens
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  token_type  :integer          default(0)
#  permit_type :integer          default(0)
#  title       :string(32)
#  token       :string(128)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AccessToken < ActiveRecord::Base
  belongs_to :user

  enum token_type: {
    system_token: 0,
    user_token: 1
  }

  enum permit_type: {
    permit_read_only: 0,
    permit_read_and_write: 1
  }

  validates :title,
            length: (1..32)

  validates :token,
            presence: true,
            uniqueness: true

  after_initialize :after_initialize

  def after_initialize
    self.token ||= SecureRandom.hex(32)
  end
end
