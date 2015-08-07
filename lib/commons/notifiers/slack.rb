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

    def post(message, article)
      @client.chat_postMessage({
                                   channel: @channel_id,
                                   username: @name,
                                   text: message,
                                   parse: 'full',
                                   unfurl_links: true,
                                   attachments: [{
                                                     fallback: article.title,
                                                     author_name: "@#{article.user.name}",
                                                     author_link: article.decorate.user.url,
                                                     author_icon: article.decorate.user.avatar_url,
                                                     color: @color,
                                                     title: article.title,
                                                     title_link: article.decorate.url,
                                                     text: article.decorate.summary,
                                                 }].to_json,
                                   icon_url: @icon.match(/\Ahttp/) ? @icon : nil,
                                   icon_emoji: @icon.match(/\A:.+:\z/) ? @icon : nil,
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
