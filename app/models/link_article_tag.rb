# frozen_string_literal: true
# == Schema Information
#
# Table name: link_article_tags
#
#  id         :integer          not null, primary key
#  article_id :string(128)
#  tag_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LinkArticleTag < ActiveRecord::Base
  belongs_to :article
  belongs_to :tag
end
