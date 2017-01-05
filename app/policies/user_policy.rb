# frozen_string_literal: true
class UserPolicy < ApplicationPolicy
  def show?
    record.present?
  end
end
