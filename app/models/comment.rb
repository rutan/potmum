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
#

class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :body,
            length: 1..2048,
            format: /[^\p{blank}\n]/

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
end
