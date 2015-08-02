class ArticleDecorator < Draper::Decorator
  delegate_all
  include DecorateSerializer
  attr :id, :user, :body, :markdown_html, :url, :view_count, :comment_count, :stock_count

  def user
    object.user.try(:decorate)
  end

  def comments
    object.comments.includes(:user).map(&:decorate)
  end

  def newest_revision
    (object.newest_revision || Revision.new).decorate
  end

  def body
    newest_revision.body
  end

  def markdown_html
    newest_revision.markdown_html
  end

  def url
    "#{GlobalSetting.root_url}#{helpers.article_path(id: object.id, name: object.user.name)}"
  end
end
