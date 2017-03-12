# frozen_string_literal: true
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
    build_revision(params)
    build_article(params)

    ActiveRecord::Base.transaction do
      @article.save!

      @revision.article_id = @article.id
      @revision.save!

      @article.newest_revision_id = @revision.id
      @article.save!

      @article.tags_text = @revision.tags_text
    end

    notify(@article) if !@published && @article.public_item?

    true
  rescue ActiveRecord::RecordInvalid => e
    @errors = e.record.errors
    false
  end

  def build_revision(params)
    @revision.user_id = params[:user_id]
    @revision.title = params[:title]
    @revision.body = params[:body]
    @revision.note = params[:note]
    @revision.tags_text = params[:tags_text]
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
  end

  def build_article(params)
    @article.user_id ||= params[:user_id]
    @article.title = params[:title]
    @article.publish_type = params[:publish_type]
    @article.published_at ||= Time.zone.now if @article.public_item?
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
