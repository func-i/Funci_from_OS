$ ->
  $('#post form').submit (e) ->
    $(this).hide()
    $('#mail-subscribe-success').show()
    # $('#post #form').css('width', 'auto')
