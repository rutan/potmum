# Potmum

[![Build Status](https://travis-ci.org/rutan/potmum.svg)](https://travis-ci.org/rutan/potmum)
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

![Potmum](./logo.png)

Potmum is cloud note-app.

## Usage

```bash
bundle install --path vendor/bundle
bundle exec puma -C config/puma.rb
```

## Requirement

- Ruby 2.2.2
- PostgreSQL

I have assumed the use in Heroku or dokku.

## Environment Variables

|ENV Name|Type|Requirement|Description|
|:---|:---|:---|:---|
|ENV['DATABASE_URL']|String|x|PostgreSQL URL|
|ENV['ROOT_URL']|String|x|Root page URL.<br>ex) http://example.com|
|ENV['COLOR_THEME']|String||default: 'blue'|
|ENV['USE_REDIRECTOR']|Boolean||Use redirector with external link|
|ENV['USE_GITHUB']|Boolean||Allow login with GitHub account|
|ENV['GITHUB_KEY']|String||GitHub API Key|
|ENV['GITHUB_SECRET']|String||GitHub API Secret Key|
|ENV['USE_SLACK']|Boolean||Allow login with Slack account|
|ENV['SLACK_KEY']|String||Slack API Key|
|ENV['SLACK_SECRET']|String||Slack API Secret Key|
|ENV['SLACK_TEAM_ID']|String||Slack Team ID<br>ex) T0123456|
|ENV['SLACK_TEAM_NAME']|String||Slack Team Name|
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
