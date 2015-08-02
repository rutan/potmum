require 'digest/md5'

class UserDecorator < Draper::Decorator
  delegate_all
  include DecorateSerializer
  attr :id, :name, :avatar_url, :stock_count

  def avatar_url
    "#{GlobalSetting.gravatar_url}/#{Digest::MD5.hexdigest(object.email.to_s)}.jpg"
  end
end
