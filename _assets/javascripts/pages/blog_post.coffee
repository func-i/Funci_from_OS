################
# Script for each blog post
# - sticky on top: social media share buttons
################

$ ->
  handleScroll = ->
    $postCanvas

  scrollTicking = false
  lastScrollY   = 0

  onScroll = ->
    lastScrollY = window.pageYOffset
    if not scrollTicking
      requestAnimationFrame( handleScroll )
      scrollTicking = true

  $postCanvas = $("#post").children(".canvas")

  $(window).scroll(onScroll)
