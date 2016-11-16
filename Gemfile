source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '4.2.5.1'
gem 'rails-i18n'

gem 'rabl'
gem 'oj'
gem 'grape'
gem 'grape-rabl'
gem 'grape-swagger'
gem 'grape-swagger-rails'

gem 'slim-rails'
gem 'sass-rails', '~> 5.0'
gem 'gemoji'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'konpow', github: 'rutan/konpow'

#gem 'active_model_serializers'
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
gem 'diffy'

gem 'mini_magick'
gem 'carrierwave'
gem 'carrierwave-aws'

gem 'nokogiri', '1.6.5'
gem 'pot_markdown'
gem 'html-pipeline-nico_link'

gem 'dotenv-rails'
gem 'foreman'

group :production do
  gem 'puma'
  gem 'pg'
  gem 'sprockets-redirect'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'thin'
  gem 'sqlite3'

  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'yard'
  gem 'annotate'
  gem 'quiet_assets'
  gem 'ruby-prof'

  gem 'rspec-rails'
  gem 'rubocop', '0.40.0'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'webmock'
  gem 'fakes3'
end
