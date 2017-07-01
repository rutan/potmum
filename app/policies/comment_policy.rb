# frozen_string_literal: true
class CommentPolicy < ApplicationPolicy
  def show?
    record.article.published?
  end
end
