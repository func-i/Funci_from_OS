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
    canvas = new Canvas
      referenceElem: $(this)
    context = new Context(canvas)

    canvas.context = context
    window.canvases.push canvas

    ##### create squares
    $('.square', this).each (index) ->
      square = new Square
        elem: $(this)
        canvas: canvas
        context: context
        id: index

    canvas.adjustSquarePositions()

    for square in canvas.squares
      square.draw()

  ##### create logo canvas and context
  if blendingSupported
    # canvas logo
    logoCanvas = new LogoCanvas
      elem: $('#logo-canvas')
    logoContext = new Context(logoCanvas)

    window.logo = new Logo
      elem: $('#logo')
      canvas: logoCanvas
      context: logoContext
      screenWidth: $(window).width()
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

  $loading = $('#loading')
  $body    = $('#body')
  
  $loading.css('opacity', '0')
  $body.css('opacity', '1')
  $loading.remove()

  ##### handle events

  # icon squares
  $noTouchIcons = $('.no-touch .square.icon')

  unless $noTouchIcons.length is 0
    $noTouchIcons.mouseover ->
      square = SquareHelper.findSquare $(this)
      square.context.clear square.left, square.top, square.sideLength, square.sideLength
      square.strokeRect "green"

    $noTouchIcons.mouseout ->
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
      LogoHelper.noTouch.mousedown
        logo: window.logo
        ev: ev
        onHome: onHome()

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
      LogoHelper.touch.tap
        logo: window.logo
        ev: ev
        onHome: onHome()

      # prevent default hammer release event from firing on tap release
      ev.gesture.stopDetect()

    holding = false
    currentHold = undefined

    $('.touch #logo').hammer({hold_timeout: 300}).on 'hold', (ev) ->
      unless logo.tooDamnSmall()
        currentHold = new Hold
          logo: window.logo
          mouseX: ev.gesture.touches[0].pageX
          mouseY: ev.gesture.touches[0].pageY
        window.logo.holding = true

    $touchLogo.hammer().on 'drag', (ev) ->
      unless logo.tooDamnSmall()
        LogoHelper.touch.drag
          logo: window.logo
          ev: ev
          hold: currentHold

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