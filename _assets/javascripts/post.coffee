$ ->
  $('#post form').submit (e) ->
    $(this).hide()
    $('#mail-list-resp').show()
    $('#btn-close-iframe').show()
    $('#post #form').css('width', 'auto')
