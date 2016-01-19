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

class Revision < ActiveRecord::Base
  belongs_to :article

  validates :body,
            length: 1..100_000,
            format: /[^\p{blank}\n]/
end
