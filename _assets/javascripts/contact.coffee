if $('#map').length > 0
  map = new L.mapbox.map "mapbox", "nasercafi.g99p0nel",
    center: [43.6445709, -79.3949665]
    zoom: 17
    zoomControl: false
    attributionControl: false
    tileLayer:
      detectRetina: true

  if Modernizr.touch
    map.dragging.disable()
    map.tap.disable()

$.fn.funciSelect = ->
  select = this
  select.hide() # hide vanilla select element

  # create span that will display selected option
  selectedOption = $('<span id="selected-option"><a></a></span>')
  select.before selectedOption

  # create expand arrow
  arrow = $('<span id="expand-arrow"><a><i class="fa fa-caret-down"></i></a></span>')
  selectedOption.after arrow

  # create ul and insert it after select
  ul = $('<ul></ul>')
  select.after ul
  ul.hide()

  $options = select.find('option')

  # create lis for each option
  $options.each ->
    optionText = $(this).text()
    ul.append("<li><a>#{optionText}</a></li>")

  selectedOption.find('a').text $options.first().text()

  toggleArrow = ->
    if ul.is(":visible")
      arrow.find('a i').removeClass('fa-caret-up').addClass('fa-caret-down')
    else
      arrow.find('a i').removeClass('fa-caret-down').addClass('fa-caret-up')

  # add data-selected to option that corresponds to clicked li
  ul.find('a').click ->
    text = $(this).text()

    select.find('option').each ->
      if $(this).attr('value') is text
        $(this).attr('selected', true) 
      else
        $(this).attr('selected', false)

    selectedOption.find('a').text(text)
    toggleArrow()
    ul.slideToggle()
    false

  selectedOption.click ->
    toggleArrow()
    ul.slideToggle()
    false

  arrow.click ->
    toggleArrow()
    ul.slideToggle()
    false
    
  $(window).click ->
    if ul.css('display') != "none"
      toggleArrow()
      ul.slideToggle()
      false

$ ->
  $('#contact select').funciSelect()

  $('#contact textarea').keydown (ev) ->
    ev.preventDefault() if ev.which is 13

  $('#contact form').submit (ev) ->
    ev.preventDefault()
    $('#form-wrapper').hide()
    $('#form-success').show()

    ResizeHelper.handleResize()

    name       = $('[name="name"]').val()
    title      = $('[name="title"]').val()
    org        = $('[name="organization"]').val()
    phone      = $('[name="phone"]').val()
    email      = $('[name="email"]').val()
    interest   = $('[name="interest"]').val()
    message    = $('[name="message"]').val()
    
    questions = $('.radiobutton-question').map((i, question) -> 
      question.textContent
    ).toArray()
    answers   = $('.radiobutton > input:radio:checked').map((i, answer) ->
      answer.value
    ).toArray()
    
    questionText = questions.reduce((str, question, i) -> 
      str += "#{question}: #{answers[i] || 'Not Answered'}\n"
    , "")
      
    rawBody = "#{message}\n\n\
    #{questionText}\n\n\
    -\n\
    #{name}\n\
    #{title ? title + '\n' : ''}\
    #{org}\n\
    #{phone ? phone + '\n' : ''}\
    #{email}"
    
    body = encodeURIComponent rawBody

    mailToLink = "mailto:info@functionalimperative.com?subject=#{interest}&body=" + body + "&target=_blank"

    # if android/ios
    if Modernizr.touch
      window.location = mailToLink
    else
      window.open mailToLink, '_blank'