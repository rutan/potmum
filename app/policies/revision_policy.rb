# frozen_string_literal: true

class RevisionPolicy < ApplicationPolicy
  def show?
    if record.published?
      true
    else
      user == record.user
    end
  end
end
