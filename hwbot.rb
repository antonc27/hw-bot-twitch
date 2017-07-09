require 'cinch'

class HwBot < Cinch::Bot
  TWITCH_OAUTH_TOKEN = '<your bot token>'
  NICKNAME = 'hwgamebot'
  CHANNEL= '#antonc27'

  def initialize(&b)
    super do
      configure do |c|
        c.server = 'irc.chat.twitch.tv'
        c.port = 6667
        c.password = 'oauth:' + TWITCH_OAUTH_TOKEN
        c.nick = NICKNAME
        c.channels = [CHANNEL]
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
    puts "10 seconds have passed"
  end
end

