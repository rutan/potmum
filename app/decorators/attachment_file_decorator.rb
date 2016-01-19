class AttachmentFileDecorator < Draper::Decorator
  delegate_all
  include DecorateSerializer
  define_attr :id, :url

  def url
    object.file.url
  end
end
