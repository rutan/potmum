# frozen_string_literal: true

class AddCommentService
  def call(access_token:, article_id:, body:)
    article = ::Article.find(article_id)
    Pundit.authorize(access_token, article, :add_comment?)

    ::Comment.create!(
      article_id: article.id,
      body: body,
      user_id: access_token.user.id
    ).tap do |comment|
      article.update_comment_count
      notify_for_slack(comment)
    end
  end

  private

  def notify_for_slack(comment)
    return unless GlobalSetting.notify_slack?

    client = Notifiers::Slack.new(
      GlobalSetting.notify_slack_token,
      channel: GlobalSetting.notify_slack_channel,
      color: GlobalSetting.theme_colors.last,
      icon: GlobalSetting.notify_slack_icon
    )
    client.post(
      "『<#{comment.article.decorate.url}|#{ERB::Util.html_escape comment.article.title}>』にコメントが付きました。",
      comment.decorate
    )
  end
end
