# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    record.present?
  end

  def show_drafts?
    user == record
  end

  def show_stocks?
    user == record
  end

  def show_likes?
    user == record
  end
end
