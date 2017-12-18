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

Boffin.config do |c|
  c.redis = Redis.current
  c.namespace = 'tracking'
  c.hours_window_secs = 3.days
  c.days_window_secs = 3.months
  c.months_window_secs = 6.months
  c.cache_expire_secs = 15.minutes
end
