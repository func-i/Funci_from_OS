$ ->
  $tweetContent = $("#tweet-content")

  handleTweet = (tweet) ->
    $tweetContent.html(tweet)
    
  if $tweetContent.length > 0
    twitterFetcher.fetch "421861421010272256", # Twitter widget ID
      "tweet-content", # The ID of the DOM element
      1,               # number of tweets
      true,            # urls and hash tags to be hyperlinked
      false,           # display user photo/name
      false,           # display time
      '',              # how display time
      false,           # display retweets
      handleTweet,
      false