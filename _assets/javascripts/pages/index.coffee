$ ->
  $tweetContent = $("#tweet-content")

  handleTweet = (tweet) ->
    $tweetContent.html(tweet)
    
  if $tweetContent.length > 0
    twitterFetcher.fetch
      id: "707675292278644736"
      domId: "tweet-content"
      maxTweets: 1
      enableLinks: true
      showUser: false
      showTime: false
      showRetweet: false
      customCallback: handleTweet
      showInteraction: false