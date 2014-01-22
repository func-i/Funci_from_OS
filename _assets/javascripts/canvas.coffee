@squares = []
@blendingSupported = Modernizr.canvasblending

findById = (elem) ->
  id = elem.data('id')
  square = _.findWhere squares, id: id

$(window).load ->
  onMobile = ->
    $('body').width() <= 640

  onHome = ->
    window.location.pathname is "/"

  ##### make square divs square

  $('.square').each ->
    $(this).css 'height', $(this).outerWidth() 

  ##### create canvas and context

  args =
    elem: $('#canvas')
  canvas = new Canvas(args)
  context = new Context(canvas)

  ##### create squares

  $('.square').each (index) ->
    args =
      elem: $(this)
      context: context
      id: index
    square = new Square(args)
    $(this).data 'id', index
    square.draw()

  ##### create logo canvas and context

  if blendingSupported
    # canvas logo
    args =
      elem: $('#logo-canvas')
    logoCanvas = new Canvas(args)
    logoContext = new Context(logoCanvas)

    args =
      elem: $('#logo')
      canvas: logoCanvas
      context: logoContext
      screenWidth: $(window).width()
    logo = new Logo(args)
  else
    # fallback logo imgs

    $logo = $('#logo')
    anchorHtml = "<a href='http://functionalimperative.com' alt='Functional Imperative'></a>"
    $logo.append anchorHtml
    $logoAnchor = $logo.find('a')

    imgFullSrc = $logo.data('imgFull')
    imgFullHtml = "<img class='full' src='#{imgFullSrc}' alt='Functional Imperative' />"
    $logoAnchor.append imgFullHtml

    imgSmallSrc = $logo.data('imgSmall')
    imgSmallHtml = "<img class='small' src='#{imgSmallSrc}' alt='Functional Imperative' />"
    $logoAnchor.append imgSmallHtml

  $('#loading').css('opacity', '0')
  $('#body').css('opacity', '1')
  $('#loading').remove()

  ##### handle events

  # icons squares

  $('.no-touch .square.icon').mouseover ->
    square = findById $(this)
    square.context.clear square.left, square.top, square.sideLength, square.sideLength
    square.strokeRect "green"

  $('.no-touch .square.icon').mouseout ->
    square = findById $(this)
    context.clear 0, 0, canvas.width, canvas.height
    for square in squares
      square.draw()

  # logo no-touch

  $noTouchLogo = $('.no-touch.canvasblending #logo')

  unless $noTouchLogo.length is 0
    $noTouchLogo.mouseover ->
      LogoHelper.noTouch.mouseover logo

    $noTouchLogo.mouseout ->
      LogoHelper.noTouch.mouseout logo

    $noTouchLogo.mousemove (ev) ->
      LogoHelper.noTouch.mousemove logo, ev

    $noTouchLogo.mousedown (ev) ->
      args =
        logo: logo
        ev: ev
        onHome: onHome()
        onMobile: onMobile() 
      LogoHelper.noTouch.mousedown args

  # logo touch

  $touchLogo = $('.touch.canvasblending #logo')

  # if on touch device that supports blending
  unless $touchLogo.length is 0
    $touchLogo.hammer().on 'touch', (ev) -> 
      mouseX = ev.gesture.center.pageX
      mouseY = ev.gesture.center.pageY

      # prevent scrolling if playing with logo
      ev.gesture.preventDefault() if logo.isUnderMouse(mouseX, mouseY)

      LogoHelper.startAnimation(logo)

    $touchLogo.hammer().on 'tap', (ev) ->
      args =
        logo: logo
        ev: ev
        onHome: onHome()
        onMobile: onMobile()
      LogoHelper.touch.tap args

      # prevent default hammer release event from firing on tap release
      ev.gesture.stopDetect()

    $touchLogo.hammer().on 'drag', (ev) ->
      args =
        logo: logo
        ev: ev
      LogoHelper.touch.drag args

    # $('.touch #logo').hammer({hold_timeout: 150}).on 'hold', (ev) ->
      
    $touchLogo.hammer().on 'release', (ev) ->
      logo.reset()
      setTimeout ->
        stopAnimations()
      , 200

  ##### resize adjustments

  resizingTimeoutId = undefined

  $(window).resize ->
    args =
      logo: logo
      canvas: canvas
      context: context
    ResizeHelper.handleResize args

  window.addEventListener "deviceorientation", ->
    args =
      logo: logo
      canvas: canvas
      context: context

    orientation = window.orientation

    if orientation isnt ResizeHelper.windowOrientation
      ResizeHelper.handleResize args
      ResizeHelper.windowOrientation = orientation