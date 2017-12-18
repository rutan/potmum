# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id                 :string(128)      not null, primary key
#  user_id            :integer
#  title              :string(128)
#  newest_revision_id :integer
#  view_count         :integer          default(0), not null
#  stock_count        :integer          default(0), not null
#  comment_count      :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  published_at       :datetime
#  publish_type       :integer          default("draft_item")
#  like_count         :integer          default(0)
#

class Article < ApplicationRecord
  include Boffin::Trackable
  boffin.hit_types = [:views, :stocks, :likes]

  belongs_to :user
  belongs_to :newest_revision, class_name: 'Revision', optional: true
  has_many :revisions, -> {
    order(published_at: :desc)
  }

  has_many :link_article_tags
  has_many :tags, through: :link_article_tags
  has_many :stocks
  has_many :likes, as: :target
  has_many :comments, -> {
    order(created_at: :asc)
  }

  enum publish_type: { draft_item: 0, private_item: 1, public_item: 2 }

  scope :published_items, -> {
    where(publish_type: [1, 2]).order(published_at: :desc)
  }

  scope :public_items, -> {
    where(publish_type: 2).order(published_at: :desc)
  }

  scope :public_or_mine, ->(author) {
    return public_items unless author
    published_articles = Article.arel_table[:publish_type].eq(2)
    mine_articles = Article.arel_table[:user_id].eq(author.id).and(Article.arel_table[:publish_type].not_eq(0))
    where(published_articles.or(mine_articles)).order(published_at: :desc)
  }

  scope :drafts, -> {
    where(publish_type: 0).order(updated_at: :desc)
  }

  scope :popular, -> {
    where(publish_type: 2).order(stock_count: :desc, view_count: :desc)
  }

  scope :hot_entries, -> {
    ids = Article.top_ids({ views: 1, likes: 1, stocks: 2 }, days: 7).take(200)
    where(publish_type: 2, id: ids).order(order_by_ids(ids))
  }

  validates :user,
            presence: true

  validates :title,
            length: 1..64,
            format: /[^\p{blank}\n]/

  paginates_per 20

  after_initialize do
    self.id ||= SecureRandom.uuid.remove('-')
  end

  def tags_text
    tags.map(&:content).join(' ')
  end

  def tags_text=(new_tags)
    ActiveRecord::Base.transaction do
      # 元々付いていたタグの削除
      link_article_tags.includes(:tag).each do |link|
        tag = link.tag
        link.destroy
        tag.update_count
      end

      # タグの追加
      new_tags.split(/\p{blank}+/)[0, 5].map { |n|
        tag = Tag.find_or_create_by_name(n)
        return nil unless tag
        LinkArticleTag.find_or_create_by(article_id: id, tag_id: tag.id)
        tag.update_count
        tag
      }.compact
    end
  end

  def published?
    published_at.present?
  end

  def update_stock_count
    old_count = stock_count
    new_count = stocks.count
    return if old_count == new_count

    update_columns(stock_count: new_count)
    user_count = user.stock_count + (new_count - old_count)
    user.update_columns(stock_count: user_count) if user_count >= 0
  end

  def update_like_count
    old_count = like_count
    new_count = likes.count
    return if old_count == new_count

    update_columns(like_count: new_count)
    user_count = user.like_count + (new_count - old_count)
    user.update_columns(like_count: user_count) if user_count >= 0
  end

  def update_comment_count
    update_columns(comment_count: comments.count)
  end
end
