# frozen_string_literal: true

Redis.current =
  if Rails.env.test?
    Redis.new(
      url: ENV['REDIS_URL']
    )
  else
    Redis::Namespace.new(
      (ENV['REDIS_NAMESPACE'] || "potmum_#{Rails.env}"),
      redis: Redis.new(
        url: ENV['REDIS_URL']
      )
    )
  end
