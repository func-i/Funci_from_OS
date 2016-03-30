$ ->
  $('.form-email form').submit (e) ->
    email   = $('input[name="EMAIL"]').val()
    emailRE = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

    if emailRE.test(email)
      $(this).hide()
      $('#mail-validate-error').hide()
      $('#mail-subscribe-success').show()
    else
      e.preventDefault()
      $(this).find('label[for="mce-EMAIL"]').css('color', '#FD00FE')
      $('#mail-validate-error').show()
