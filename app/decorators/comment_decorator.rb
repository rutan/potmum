class CommentDecorator < Draper::Decorator
  delegate_all
  include DecorateSerializer
  include MarkdownRenderable
  define_attr :id, :user, :body, :markdown_html, :url
  markdown_column :body

  def user
    object.user.try(:decorate)
  end

  def url
    return nil unless object.article.try(:id)
    buffer = []
    buffer.push GlobalSetting.root_url
    buffer.push helpers.article_path(id: object.article.id, name: object.article.user.name)
    buffer.push "#comment-#{object.id}"
    buffer.join('')
  end

  def summary(size = 64)
    helpers.truncate(helpers.strip_tags(markdown_html), length: size)
  end
end
