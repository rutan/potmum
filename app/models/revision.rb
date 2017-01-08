# frozen_string_literal: true
# == Schema Information
#
# Table name: revisions
#
#  id            :integer          not null, primary key
#  article_id    :string(128)
#  body          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  title         :string           default("")
#  tags_text     :text             default("")
#  user_id       :integer
#  published_at  :datetime
#  revision_type :integer          default(0)
#  note          :text
#

class Revision < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :user,
            presence: true

  validates :title,
            length: 1..64,
            format: /[^\p{blank}\n]/

  validates :body,
            length: 1..100_000,
            format: /[^\p{blank}\n]/

  validates :revision_type,
            inclusion: { in: %w(draft published) }

  validates :note,
            length: 0..1000

  enum revision_type: {
    unknown: 0,
    draft: 1,
    published: 2
  }

  scope :published, -> {
    where(revision_type: 2).order(published_at: :desc, id: :desc)
  }

  scope :drafts, -> {
    where(revision_type: 1).order(published_at: :desc, id: :desc)
  }

  def prev_revision
    Revision
      .published
      .where(article_id: article_id)
      .where(self.class.arel_table[:published_at].lt(published_at))
      .first
  end
end
