class ArticleBuilder
  def initialize(article)
    @article = article
    @published = article.published?
    @revision = @article.revisions.drafts.first || Revision.new
    @errors = nil
  end

  attr_reader :article
  attr_reader :errors

  def build(params)
    @revision.user_id = params.delete(:user_id)
    @article.user_id ||= @revision.user_id

    @revision.title = params.delete(:title)
    @revision.body = params.delete(:body)
    @revision.note = params.delete(:note).to_s
    @revision.tags_text = params.delete(:tags_text).to_s
    @revision.published_at = Time.zone.now
    @revision.revision_type =
      case params[:publish_type]
      when 'private_item', 'public_item'
        Revision.revision_types[:published]
      else
        Revision.revision_types[:draft]
      end

    unless @revision.valid?
      @errors = @revision.errors
      Rails.logger.debug @error.inspect
      raise Errors::BadRequest
    end

    ActiveRecord::Base.transaction do
      @revision.save!

      @article.user_id ||= @revision.user_id
      @article.title = @revision.title
      @article.newest_revision_id = @revision.id
      @article.publish_type = params[:publish_type]
      @article.published_at ||= Time.zone.now if @revision.published?
      @article.save!

      @article.tags_text = @revision.tags_text
      @revision.article_id = @article.id
      @revision.save!
    end

    notify(@article) if !@published && @article.public_item?

    true
  rescue ActiveRecord::RecordInvalid => e
    @errors = e.record.errors
    false
  end

  def notify(article)
    return unless GlobalSetting.notify_slack?

    client = Notifiers::Slack.new(
      GlobalSetting.notify_slack_token,
      channel: GlobalSetting.notify_slack_channel,
      color: GlobalSetting.theme_colors.last,
      icon: GlobalSetting.notify_slack_icon
    )
    client.post(
      "『<#{article.decorate.url}|#{ERB::Util.html_escape article.title}>』が投稿されました",
      article.decorate
    )
  end
end
