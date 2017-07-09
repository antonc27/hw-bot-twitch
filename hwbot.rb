require 'cinch'
require 'httparty'

class HwBot < Cinch::Bot
  TWITCH_OAUTH_TOKEN = '<your bot token>'
  NICKNAME = 'hwgamebot'
  CHANNEL_NAME = 'antonc27'

  def initialize(&b)
    super do
      configure do |c|
        c.server = 'irc.chat.twitch.tv'
        c.port = 6667
        c.password = 'oauth:' + TWITCH_OAUTH_TOKEN
        c.nick = NICKNAME
        c.channels = ["##{CHANNEL_NAME}"]
        c.plugins.plugins = [Hello, TimedPlugin]
      end
    end
  end
end

class Hello
  include Cinch::Plugin

  match "hello"

  def execute(m)
    m.reply "Hellos, #{m.user.nick}"
  end
end

class TimedPlugin
  include Cinch::Plugin

  timer 10, method: :timed
  def timed
    puts '10 seconds have passed'
    get_chatters
  end

  def get_chatters
    url = "https://tmi.twitch.tv/group/user/#{HwBot::CHANNEL_NAME}/chatters"
    response = HTTParty.get(url)
    return if response.code != 200
    json = JSON.parse(response.body)
    chatters = (json['chatter_count'].to_i > 0) ? json['chatters']['viewers'] : []
    puts 'Viewers: ' + chatters.to_s
  end
end
