$ ->
  $('#post form').submit (e) ->
    email   = $('input[name="EMAIL"]').val()
    emailRE = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

    if emailRE.test(email)
      $(this).hide()
      $('#mail-validate-error').hide()
      $('#mail-subscribe-success').show()
    else
      e.preventDefault()
      $('#mail-validate-error').show()
