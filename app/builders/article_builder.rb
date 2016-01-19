class ArticleBuilder
  def initialize(article)
    @article = article
    @published = article.published?
    @revision = Revision.new
    @error = nil
  end

  attr_reader :article
  attr_reader :error

  def build(params)
    ActiveRecord::Base.transaction do
      @article.title = params.delete(:title)
      raise Errors::BadRequest unless @article.valid?

      @revision.body = params.delete(:body)
      raise Errors::BadRequest unless @revision.valid?
      @revision.save!

      @article.newest_revision_id = @revision.id
      @article.publish_type = params[:publish_type] if params[:publish_type]
      @article.published_at ||= Time.zone.now unless @article.draft_item?
      @article.save!

      @article.tags_text = params.delete(:tags_text).to_s

      @revision.article_id = @article.id
      @revision.save
    end

    if !@published && @article.public_item?
      notify(@article)
    end

    true
  rescue => e
    @error = 'だめっぽ'
    false
  end

  def notify(article)
    if GlobalSetting.notify_slack?
      client = Notifiers::Slack.new(GlobalSetting.notify_slack_token,
                                    channel: GlobalSetting.notify_slack_channel,
                                    color: GlobalSetting.theme_colors.last,
                                    icon: GlobalSetting.notify_slack_icon,
      )
      client.post("『<#{article.decorate.url}|#{ERB::Util.html_escape article.title}>』が投稿されました", article.decorate)
    end
  end
end
