class CommentDecorator < Draper::Decorator
  delegate_all
  include DecorateSerializer
  include MarkdownRenderable
  attr :id, :user, :body, :markdown_html, :url
  markdown_column :body

  def user
    object.user.try(:decorate)
  end

  def url
    return nil unless object.article.try(:id)
    "#{GlobalSetting.root_url}#{helpers.article_path(id: object.article.id, name: object.article.user.name)}#comment-#{object.id}"
  end
end
