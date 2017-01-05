# frozen_string_literal: true
class RevisionDecorator < Draper::Decorator
  delegate_all
  include DecorateSerializer
  include MarkdownRenderable
  define_attr :body, :markdown_html
  markdown_column :body

  def body
    object.body.to_s
  end
end
