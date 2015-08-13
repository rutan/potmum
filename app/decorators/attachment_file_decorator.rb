class AttachmentFileDecorator < Draper::Decorator
  delegate_all
  include DecorateSerializer
  attr :id, :url

  def url
    object.file.url
  end
end
