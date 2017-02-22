# frozen_string_literal: true
# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(32)       not null
#  uid        :string(128)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Authentication < ApplicationRecord
  belongs_to :user

  def provider_name
    SERVICE_NAMES[provider]
  end

  def self.enable_services
    @enable_services ||= begin
      services = SERVICE_NAMES.dup
      services.delete(:google_oauth2) unless ENV['USE_GOOGLE'].to_i != 0
      services.delete(:github) unless ENV['USE_GITHUB'].to_i != 0
      services.delete(:slack) unless ENV['USE_SLACK'].to_i != 0
      services.delete(:slack) unless ENV['USE_TWITTER'].to_i != 0
      services
    end
  end

  SERVICE_NAMES = {
    google_oauth2: ENV['GOOGLE_APPS_DOMAIN'].present? ? ENV['GOOGLE_APPS_DOMAIN'] : 'Google',
    github: ENV['GITHUB_ENTERPRISE_URL'] ? 'GitHub:e' : 'GitHub',
    slack: "Slack#{ENV['SLACK_TEAM_NAME'] ? "(#{ENV['SLACK_TEAM_NAME']})" : ''}",
    twitter: 'Twitter'
  }.with_indifferent_access
end
