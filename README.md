# Potmum

[![Build Status](https://travis-ci.org/rutan/potmum.svg)](https://travis-ci.org/rutan/potmum)
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

![Potmum](./logo.png)

Potmum is cloud note-app.

Demo: https://potmum-demo.herokuapp.com/

## Usage

development mode

```bash
yarn install
bundle install --path vendor/bundle
bundle exec rake db:create db:migrate
bundle exec foreman start -f Procfile.dev
```

production mode

```bash
yarn install
bundle install --path vendor/bundle
RAILS_ENV=production bundle exec rake db:create db:migrate assets:precompile
RAILS_ENV=production bundle exec puma -C config/puma.rb
```

## Requirement

- Ruby 2.3.1
- PostgreSQL
- Node (>= v.6.0) and [yarn](https://github.com/yarnpkg/yarn)

I have assumed the use in Heroku or dokku.

## Environment Variables

|ENV Name|Type|Requirement|Description|
|:---|:---|:---|:---|
|ENV['DATABASE_URL']|String|x|PostgreSQL URL|
|ENV['ROOT_URL']|String|x|Root page URL.<br>ex) http://example.com|
|ENV['COLOR_THEME']|String||default: 'blue'|
|ENV['USE_REDIRECTOR']|Boolean||Use redirector with external link|
|ENV['USE_GOOGLE']|Boolean||Allow login with Google OAuth 2|
|ENV['GOOGLE_KEY']|String||Google OAuth2 API Key|
|ENV['GOOGLE_SECRET']|String||Google OAuth2 Secret Key|
|ENV['GOOGLE_APPS_DOMAIN']|String||*only use Google Apps Account*<br>Google Apps Domains<br>(ex. `hazimu.com, example.com`)|
|ENV['USE_GITHUB']|Boolean||Allow login with GitHub account|
|ENV['GITHUB_KEY']|String||GitHub API Key|
|ENV['GITHUB_SECRET']|String||GitHub API Secret Key|
|ENV['GITHUB_ENTERPRISE_URL']|String|*only use github:e*<br>GitHub Enterprise URL|
|ENV['USE_SLACK']|Boolean||Allow login with Slack account|
|ENV['SLACK_KEY']|String||Slack API Key|
|ENV['SLACK_SECRET']|String||Slack API Secret Key|
|ENV['SLACK_TEAM_ID']|String||Slack Team ID<br>ex) T0123456|
|ENV['SLACK_TEAM_NAME']|String||Slack Team Name|
|ENV['USE_TWITTER']|Boolean||Allow login with Twitter account|
|ENV['TWITTER_KEY']|String||Twitter API Key|
|ENV['TWITTER_SECRET']|String||Twitter API Secret Key|
|ENV['NOTIFY_SLACK_CHANNEL']|String||Notify channel<br>ex) #general|
|ENV['NOTIFY_SLACK_ICON']|String||Slack icon URL or emoji|
|ENV['NOTIFY_SLACK_TOKEN']|String||Slack API Token|
|ENV['GLOBAL_ALERT']|String||Footer message|
|ENV['PRIVATE_MODE']|Boolean||Members only mode|
|ENV['USE_ATTACHMENT_FILE']|Boolean||Use Attachment File<br>default: false|
|ENV['ATTACHMENT_FILE_S3_BUCKET']|Boolean||Members only mode|
|ENV['ATTACHMENT_FILE_S3_ACL']|Boolean||s3 ACL<br>default: public-read|
|ENV['ATTACHMENT_FILE_S3_HOST']|Boolean||s3 asset host|
|ENV['ATTACHMENT_FILE_S3_KEY']|Boolean||s3 access key|
|ENV['ATTACHMENT_FILE_S3_SECRET']|Boolean||s3 token secret|
|ENV['ATTACHMENT_FILE_S3_REGION']|Boolean||s3 region|
|ENV['ATTACHMENT_FILE_S3_ENDPOINT']|Boolean||S3 endpoint|
|ENV['ATTACHMENT_FILE_S3_FORCE_PATH_STYLE']|Boolean||use force path style in S3|

## Color Theme
- red
- pink
- purple
- deep_purple
- indigo
- blue
- light_blue
- cyan
- teal
- green
- light_green
- lime
- yellow
- amber
- orange
- deep_orange
- brown
- grey
- blue_grey

## LICENSE
MIT License
