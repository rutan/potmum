# frozen_string_literal: true

class TagDecorator < Draper::Decorator
  delegate_all
  include DecorateSerializer
  define_attr :id, :content, :article_count, :is_menu

  def uuid
    "#{object.class.name}::#{object.key}"
  end
end
