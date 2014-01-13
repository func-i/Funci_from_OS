@squares = []

findById = (elem) ->
  id = elem.data('id')
  square = _.findWhere squares, id: id

$ ->
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

  # squares

  # $('.square[data-rollover="true"]').mouseover ->
  #   square = findById $(this)
  #   square.state = 'hover'
  #   animationId = requestAnimationFrame -> animateSquare(square, canvas, context)
  #   animationIds.push animationId

  # $('.square[data-rollover="true"]').mouseout ->
  #   square = findById $(this)
  #   square.state = 'static'
  #   setTimeout ->
  #     stopAnimations()
  #   , 200

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
      $(this).mouseleave ->
        logo.reset()

  $('#logo').mousedown (ev) ->
    if logo.isUnderMouse ev.pageX, ev.pageY
      logo.explode ev.pageX, ev.pageY
      $(this).mouseup ->
        if logo.full then logo.contract() else logo.expand()
        $(this).unbind('mouseup')

  # cancel if mouseleave window
  $(document).mouseleave ->
    logo.reset()
    for square in squares
      square.state = 'static'
    setTimeout ->
      stopAnimations()
    , 50

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