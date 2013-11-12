require 'twitter'
require 'yaml'

CONFIG = YAML.load_file("twitter_auth.yaml")

module Jekyll
  class LatestTweet < Liquid::Tag
    def initialize(tag_name, text, tokens)
      @client = Twitter.configure do |config|
        config.consumer_key        = CONFIG["consumer_key"]
        config.consumer_secret     = CONFIG["consumer_secret"]
        config.oauth_token         = CONFIG["oauth_token"]
        config.oauth_token_secret  = CONFIG["oauth_token_secret"]
      end
    end

    def render(context)
      raw_tweet = @client.user_timeline("func_i")[0]
      tweet = raw_tweet.text
      # need to format html here!
    end
  end
end

Liquid::Template.register_tag('latest_tweet', Jekyll::LatestTweet)