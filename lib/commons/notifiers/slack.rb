# frozen_string_literal: true

require 'slack'

module Notifiers
  class Slack
    def initialize(token, channel: '#general', name: 'Potmum', icon: nil, color: '#999')
      @client = ::Slack.client(token: token)
      @channel_id = self.class.channel_id(@client, channel)
      @name = name
      @icon = icon.to_s
      @color = color
    end

    def post(message, target)
      @client.chat_postMessage({
        channel: @channel_id,
        username: @name,
        text: message,
        parse: 'none',
        unfurl_links: true,
        attachments: [{
          fallback: target.try(:title) || target.try(:summary),
          author_name: "@#{target.user.name}",
          author_link: target.user.url,
          author_icon: target.user.avatar_url,
          color: @color,
          title: target.try(:title),
          title_link: target.try(:url),
          text: target.try(:summary)
        }.delete_if { |_, v| v.nil? }].to_json,
        icon_url: @icon.start_with?('http') ? @icon : nil,
        icon_emoji: @icon.match?(/\A:.+:\z/) ? @icon : nil
      }.delete_if { |_, v| v.nil? })
    end

    def self.channel_id(client, name)
      channel_name = name.sub(/\A#/, '')
      @channel_list = (client.channels_list['channels'] || [])
      channel = @channel_list.find { |n| n['name'] == channel_name }
      channel.try(:[], 'id') || raise('not found channel')
    end
  end
end
