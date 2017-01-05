# frozen_string_literal: true
class Like < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :user
end
