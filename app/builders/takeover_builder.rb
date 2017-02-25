# frozen_string_literal: true
class TakeoverBuilder
  def initialize(user)
    @user = user
    @errors = nil
  end

  attr_reader :user, :errors

  def build(from_user)
    ActiveRecord::Base.transaction do
      # takeover
      [Article, AttachmentFile, Comment, Revision].each do |klass|
        klass.where(user_id: from_user.id).update_all(user_id: @user.id)
      end

      # delete
      [AccessToken, Authentication, Like, Stock].each do |klass|
        klass.where(user_id: from_user.id).delete_all
      end

      from_user.destroy!
    end
  end
end
