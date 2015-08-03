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
#

class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :newest_revision, class_name: 'Revision'
  has_many :revisions
  has_many :link_article_tags
  has_many :tags, through: :link_article_tags
  has_many :stocks
  has_many :comments, -> {
    order(created_at: :asc)
  }

  scope :published, -> {
    where.not(published_at: nil).order(published_at: :desc)
  }

  scope :drafts, -> {
    where(published_at: nil).order(updated_at: :desc)
  }

  scope :popular, -> {
    where.not(published_at: nil).order(stock_count: :desc, view_count: :desc)
  }

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
      self.link_article_tags.includes(:tag).each do |link|
        tag = link.tag
        link.destroy
        tag.update_count
      end

      # タグの追加
      new_tags.split(/\p{blank}+/)[0, 5].map { |n|
        tag = Tag.find_or_create_by_name(n)
        return nil unless tag
        link = LinkArticleTag.find_or_create_by(article_id: id, tag_id: tag.id)
        puts link.inspect
        tag.update_count
        tag
      }.compact
    end
  end

  def published?
    published_at.present?
  end

  def update_count
    old_count = self.stock_count
    new_count = self.stocks.count
    if old_count != new_count
      update_columns(stock_count: new_count)
      user_count = self.user.stock_count + (new_count - old_count)
      user.update_columns(stock_count: user_count) if user_count >= 0
    end
  end

  def update_comment_count
    update_columns(comment_count: self.comments.count)
  end
end
