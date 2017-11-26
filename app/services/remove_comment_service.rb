# frozen_string_literal: true

class RemoveCommentService
  def call(access_token:, comment_id: nil, comment_key: nil)
    comment =
      case
      when comment_id
        ::Comment.find(comment_id)
      when comment_key
        ::Comment.find_by!(key: comment_key)
      end
    Pundit.authorize(access_token, comment, :destroy?)
    comment.destroy!
    comment.article.update_comment_count
    comment.article
  end
end
