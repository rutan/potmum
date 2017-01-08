# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  name        :string(32)       not null
#  email       :string
#  stock_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  role        :integer          default(0)
#

class User < ApplicationRecord
  has_many :authentications
  has_many :articles
  has_many :comments, -> {
    order(created_at: :desc)
  }
  has_many :stocks, -> {
    order(created_at: :desc)
  }
  has_many :stock_articles, through: :stocks, source: 'article'
  has_many :likes, -> {
    order(created_at: :desc)
  }
  has_many :access_tokens

  validates :name,
            length: 3..16,
            format: /\A[A-Za-z0-9\-_]+\z/,
            uniqueness: true

  validates :email,
            length: 3..255,
            format: /\A.+@.+\z/,
            allow_blank: true

  def to_param
    name
  end

  def link_to_auth(auth)
    return false if authentications.where(provider: auth['provider']).exists?
    Authentication.create(user: self, provider: auth['provider'], uid: auth['uid'])
  end

  def link_to_auth!(auth)
    link_to_auth(auth) || raise('failed')
  end

  def liked?(article)
    likes.where(target_type: 'Article', target_id: article.id).exists?
  end

  def stocked?(article)
    stocks.where(article_id: article.id).exists?
  end

  def self.find_by_auth(auth)
    Authentication.find_by(provider: auth['provider'], uid: auth['uid']).try(:user)
  end

  def self.create_by_name_and_auth(name, auth)
    raise 'exist user' if find_by_auth(auth)

    user = User.create(name: name)
    Authentication.create(user: user, provider: auth['provider'], uid: auth['uid'])
    user
  end
end
