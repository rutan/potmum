source 'https://rubygems.org'
ruby '2.3.0'

gem 'rails', '4.2.5.1'
gem 'rails-i18n'

gem 'slim-rails'
gem 'sass-rails', '~> 5.0'
gem 'compass-rails'
gem 'font-awesome-sass'
gem 'jquery-rails'
gem 'gemoji'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby

gem 'active_model_serializers'
gem 'draper'

gem 'omniauth'
gem 'omniauth-google-oauth2',
    github: 'zquestz/omniauth-google-oauth2', ref: '69c3e91f158337a3804e5d69291085125aa55a7e' # multi domains
gem 'omniauth-github'
gem 'omniauth-slack'
gem 'omniauth-twitter'

gem 'slack-api'

gem 'kaminari'
gem 'ransack'

gem 'mini_magick'
gem 'carrierwave'
gem 'carrierwave-aws', github: 'sorentwo/carrierwave-aws', ref: '64f8d1e4af92b25b6a2e1e4bd4e97e8586174913'

gem 'nokogiri', '1.6.5'
gem 'qiita-markdown', github: 'rutan/qiita-markdown', branch: 'remove_linguist'
gem 'html-pipeline-nico_link'

gem 'dotenv-rails'

group :production do
  gem 'puma'
  gem 'pg'
  gem 'sprockets-redirect'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'thin'
  gem 'sqlite3'
  gem 'ikazuchi'
  gem 'faker'
  gem 'quiet_assets'
  gem 'annotate'
  gem 'fakes3'
  gem 'foreman'
  gem 'ruby-prof'
end
