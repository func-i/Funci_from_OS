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

  ##### create logo canvas and context

  args =
    elem: $('#logo-canvas')
  logoCanvas = new Canvas(args)
  logoContext = new Context(logoCanvas)

  ##### create squares

  $('.square').each (index) ->
    args =
      elem: $(this)
      context: context
      id: index
    square = new Square(args)
    $(this).data 'id', index
    square.draw()

  ##### create logo

  args =
    elem: $('#logo')
    canvas: logoCanvas
    context: logoContext
    screenWidth: $(window).width()
  logo = new Logo(args)

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

  $('.no-touch #logo').mouseover ->
    LogoEvents.noTouch.mouseover logo

  $('.no-touch #logo').mouseout ->
    LogoEvents.noTouch.mouseout logo

  $('.no-touch #logo').mousemove (ev) ->
    LogoEvents.noTouch.mousemove logo, ev

  $('.no-touch #logo').mousedown (ev) ->
    args =
      logo: logo
      ev: ev
      onHome: onHome()
      onMobile: onMobile() 
    LogoEvents.noTouch.mousedown args

  # logo touch

  $('.touch #logo').hammer().on 'touch', (ev) ->
    LogoEvents.startAnimation(logo)

  $('.touch #logo').hammer().on 'tap', (ev) ->
    args =
      logo: logo
      ev: ev
      onHome: onHome()
      onMobile: onMobile()
    LogoEvents.touch.tap args

    # prevent default hammer release event from firing
    ev.gesture.stopDetect()

  $('.touch #logo').hammer().on 'drag', (ev) ->
    args =
      logo: logo
      ev: ev
    LogoEvents.touch.drag args

  # $('.touch #logo').hammer({hold_timeout: 150}).on 'hold', (ev) ->
    
  $('.touch #logo').hammer().on 'release', (ev) ->
    logo.reset()
    setTimeout ->
      stopAnimations()
    , 200

  document.getElementById('logo').ontouchmove = (ev) ->
    ev.preventDefault()

  ##### resize adjustments

  resizingTimeoutId = undefined

  $(window).resize ->
    # continue if still resizing
    clearTimeout resizingTimeoutId

    $('.square').each ->
      $(this).css 'height', $(this).outerWidth()

    animationId = requestAnimationFrame -> animateAllSquares(canvas, context)
    animationIds.push animationId

    logo.resize $(window).innerWidth()
    animationId = requestAnimationFrame -> animateLogo(logo, logoCanvas, logoContext)
    animationIds.push animationId

    canvas.orient $('body').width(), $('body').height()
    context.setMultiply()

    logoCanvas.orient $('body').width(), $('body').height()
    logoContext.setMultiply()

    # haven't resized in 300ms!
    resizingTimeoutId = setTimeout ->
      stopAnimations()
    , 200 