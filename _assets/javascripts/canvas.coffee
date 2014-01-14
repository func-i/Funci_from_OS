@squares = []

findById = (elem) ->
  id = elem.data('id')
  square = _.findWhere squares, id: id

$ ->
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
    context: logoContext
    screenWidth: $(window).width()
  logo = new Logo(args)

  ##### handle events

  # icons squares

  $('.square.icon').mouseover ->
    square = findById $(this)
    square.context.clear square.left, square.top, square.sideLength, square.sideLength
    square.strokeRect "green"

  $('.square.icon').mouseout ->
    square = findById $(this)
    context.clear 0, 0, canvas.width, canvas.height
    for square in squares
      square.draw()

  # logo

  $('#logo').mouseover (ev) ->
    animationId = requestAnimationFrame -> animateLogo(logo, logoCanvas, logoContext)
    animationIds.push animationId

  $('#logo').mouseout (ev) ->
    logo.reset()
    setTimeout ->
      stopAnimations()
    , 100

  $('#logo').mousemove (ev) ->
    if logo.full
      logo.animate ev.pageX, ev.pageY
    if logo.isUnderMouse ev.pageX, ev.pageY
      $(this).css('cursor', 'pointer')
    else
      $(this).css('cursor', 'default')

  $('#logo').mousedown (ev) ->
    mouseX = ev.pageX
    mouseY = ev.pageY
    if (logo.isUnderMouse mouseX, mouseY)
      unless onMobile() then logo.explode mouseX, mouseY
      $(this).mouseup ->
        if !onHome()
          window.location.replace("/")
        else
          unless onMobile()
            if logo.full then logo.contract() else logo.expand()
        $(this).unbind('mouseup')

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