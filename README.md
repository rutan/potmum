# Potmum

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
|ENV['GLOBAL_ALERT']|String||Footer message|

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
