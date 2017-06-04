# frozen_string_literal: true
class UserPolicy < ApplicationPolicy
  def show?
    record.present?
  end

  def show_drafts?
    user == record
  end
end
