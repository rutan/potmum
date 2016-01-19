Rails.application.config.middleware.use OmniAuth::Builder do
  # GitHub
  if ENV['USE_GITHUB']
    if ENV['GITHUB_ENTERPRISE_URL']
      url = ENV['GITHUB_ENTERPRISE_URL'].sub(/\/\z/, '')
      provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], client_options: {
        site: "#{url}/api/v3",
        authorize_url: "#{url}/login/oauth/authorize",
        token_url: "#{url}/login/oauth/access_token"
      }
    else
      provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    end
  end

  # Slack
  if ENV['USE_SLACK']
    options = {
      scope: 'identify,read',
      team: ENV['SLACK_TEAM_ID']
    }.select { |_, v| v.present? }
    provider :slack, ENV['SLACK_KEY'], ENV['SLACK_SECRET'], options
  end

  # Twitter
  if ENV['USE_TWITTER']
    provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  end
end
