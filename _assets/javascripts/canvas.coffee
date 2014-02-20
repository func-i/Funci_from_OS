window.canvases = []
window.logo = {}
@blendingSupported = Modernizr.canvasblending  

$(window).load ->
  onHome = ->
    window.location.pathname is "/"

  ##### make square divs square
  $('.square').each ->
    $square = $(this)
    $square.css 'width', ''
    roundedWidth = Math.round $square.outerWidth()
    $square.css 'width', roundedWidth
    $square.css 'height', roundedWidth

  ##### create canvases and corresponding contexts
  $('.canvas').each (index) ->
    args =
      referenceElem: $(this)
    canvas = new Canvas(args)
    context = new Context(canvas)

    canvas.context = context
    window.canvases.push canvas

    ##### create squares
    $('.square', this).each (index) ->
      args =
        elem: $(this)
        canvas: canvas
        context: context
        id: index
      square = new Square(args)

    canvas.adjustSquarePositions()

    for square in canvas.squares
      square.draw()

  ##### create logo canvas and context
  if blendingSupported
    # canvas logo
    args =
      elem: $('#logo-canvas')
    logoCanvas = new LogoCanvas(args)
    logoContext = new Context(logoCanvas)

    args =
      elem: $('#logo')
      canvas: logoCanvas
      context: logoContext
      screenWidth: $(window).width()
    window.logo = new Logo(args)
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

  ##### fade in

  $('#loading').css('opacity', '0')
  $('#body').css('opacity', '1')
  $('#loading').remove()

  ##### handle events

  # icons squares
  $('.no-touch .square.icon').mouseover ->
    square = SquareHelper.findSquare $(this)
    square.context.clear square.left, square.top, square.sideLength, square.sideLength
    square.strokeRect "green"

  $('.no-touch .square.icon').mouseout ->
    square = SquareHelper.findSquare $(this)
    square.context.clear 0, 0, square.canvas.width, square.canvas.height
    for square in square.canvas.squares
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
        logo: window.logo
        ev: ev
        onHome: onHome()
      LogoHelper.noTouch.mousedown args

  # logo touch
  $touchLogo = $('.touch.canvasblending #logo')

  # if on touch device that supports blending
  unless $touchLogo.length is 0
    $touchLogo.hammer().on 'touch', (ev) ->
      mouseX = ev.gesture.touches[0].pageX
      mouseY = ev.gesture.touches[0].pageY

      # prevent scrolling if playing with logo
      ev.gesture.preventDefault() if window.logo.isUnderMouse(mouseX, mouseY)

      LogoHelper.startAnimation(window.logo)

    $touchLogo.hammer().on 'tap', (ev) ->
      args =
        logo: window.logo
        ev: ev
        onHome: onHome()
      LogoHelper.touch.tap args

      # prevent default hammer release event from firing on tap release
      ev.gesture.stopDetect()

    holding = false
    currentHold = undefined

    $('.touch #logo').hammer({hold_timeout: 300}).on 'hold', (ev) ->
      args =
        logo: window.logo
        mouseX: ev.gesture.touches[0].pageX
        mouseY: ev.gesture.touches[0].pageY
      currentHold = new Hold(args)
      window.logo.holding = true

    $touchLogo.hammer().on 'drag', (ev) ->
      args =
        logo: window.logo
        ev: ev
        hold: currentHold
      LogoHelper.touch.drag args

    pinchStarted = false
    currentPinch = undefined
      
    $touchLogo.hammer().on 'release', (ev) ->
      window.logo.holding = false
      currentHold.end() if currentHold isnt undefined
      currentHold = undefined
      window.logo.returnHome()
      setTimeout ->
        stopAnimations()
      , 200
      pinchStarted = false

  ##### resize adjustments

  $(window).resize ->
    ResizeHelper.handleResize()

  $(window).bind 'orientationchange', ->
    orientation = window.orientation

    if orientation isnt ResizeHelper.windowOrientation
      ResizeHelper.handleResize()
      ResizeHelper.windowOrientation = orientation