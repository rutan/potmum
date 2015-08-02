# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  article_id :string(128)      not null
#  user_id    :integer
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  validates :body,
            length: 1..2048,
            format: /[^\p{blank}\n]/

  scope :recent, -> {
    order(created_at: :desc)
  }
end
