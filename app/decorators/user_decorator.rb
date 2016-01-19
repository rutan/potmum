require 'digest/md5'

class UserDecorator < Draper::Decorator
  delegate_all
  include DecorateSerializer
  define_attr :id, :name, :avatar_url, :stock_count

  def avatar_url
    "#{GlobalSetting.gravatar_url}/#{Digest::MD5.hexdigest(object.email.to_s)}.jpg"
  end

  def url
    "#{GlobalSetting.root_url}#{helpers.user_path(name: object.name)}"
  end
end
