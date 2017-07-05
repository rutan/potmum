# frozen_string_literal: true
class CommentPolicy < ApplicationPolicy
  def show?
    record.article.published?
  end

  def destroy?
    show? && user == record.user
  end
end
