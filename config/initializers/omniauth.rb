# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  # Google
  if ENV['USE_GOOGLE']
    options = {
      hd: ENV['GOOGLE_APPS_DOMAIN'].to_s.split(/\s*,\s*/),
      prompt: 'select_account'
    }.select { |_, v| v.present? }
    provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], options
  end

  # GitHub
  if ENV['USE_GITHUB']
    if ENV['GITHUB_ENTERPRISE_URL']
      url = ENV['GITHUB_ENTERPRISE_URL'].sub(%r{/\z}, '')
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
      scope: 'team:read,users.profile:read,identify',
      team: ENV['SLACK_TEAM_ID']
    }.select { |_, v| v.present? }
    provider :slack, ENV['SLACK_KEY'], ENV['SLACK_SECRET'], options
  end

  # Twitter
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'] if ENV['USE_TWITTER']

  # Developer
  provider :developer, fields: [:nickname], uid_field: :nickname if ENV['USE_DEVELOPER']
end

OmniAuth.config.on_failure = proc do |env|
  SessionsController.action(:failure).call(env)
end
