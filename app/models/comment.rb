# frozen_string_literal: true
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
#  key        :string(128)
#

class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :body,
            length: 1..2048,
            format: /[^\p{blank}\n]/

  validates :key,
            presence: true,
            uniqueness: true

  after_initialize do
    self.key ||= SecureRandom.uuid.remove('-')
  end

  scope :recent, -> (author = nil) {
    published_articles = Article.arel_table[:publish_type].eq(2)
    recent_scope =
      if author
        mine_articles = Article.arel_table[:user_id].eq(author.id).and(Article.arel_table[:publish_type].not_eq(0))
        published_articles.or(mine_articles)
      else
        published_articles
      end
    joins(:article).where(recent_scope).order(created_at: :desc)
  }

  class << self
    def find_by_uuid_value(uuid_value)
      find_by(key: uuid_value)
    end
  end
end
