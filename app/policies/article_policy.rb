# frozen_string_literal: true
class ArticlePolicy < ApplicationPolicy
  def show?
    case record.publish_type
    when 'private_item', 'public_item'
      true
    when 'draft_item'
      user == record.user
    else
      raise 'unknown publish type'
    end
  end
end
