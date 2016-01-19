# == Schema Information
#
# Table name: tags
#
#  id            :integer          not null, primary key
#  name          :string(64)       not null
#  content       :string(64)       not null
#  article_count :integer          default(0), not null
#  is_menu       :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Tag < ActiveRecord::Base
  has_many :link_article_tags
  has_many :articles, through: :link_article_tags

  validates :content,
            length: 1..40,
            uniqueness: true,
            format: /\A[^\p{blank}\n]+\z/

  scope :enabled, -> {
    where('article_count > ?', 0)
  }

  scope :popular, -> {
    enabled.order(article_count: :desc)
  }

  scope :recent_updated, -> {
    enabled.order(updated_at: :desc)
  }

  scope :menu, -> {
    where(is_menu: true).order(name: :asc)
  }

  def to_param
    content
  end

  def content=(str)
    super(self.class.normalize(str))
    self.name ||= str
  end

  def name=(str)
    super(str)
    self.content = str unless content == self.class.normalize(str)
  end

  def menu?
    !!is_menu
  end

  def update_count
    update(article_count: articles.public_items.count)
  end

  def self.find_or_create_by_name(str)
    tag = find_or_initialize_by(content: normalize(str))
    tag.name = str if tag.new_record?
    tag.save ? tag : nil
  end

  require 'nkf'
  def self.normalize(str)
    NKF.nkf('-m0Z1 -W -w', str.downcase)
  end
end
