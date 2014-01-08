@squares = []

findById = (elem) ->
  id = elem.data('id')
  square = _.findWhere squares, id: id

@animationId = undefined

$ ->
  ##### make square divs square

  $('.square').each ->
    $(this).css 'height', $(this).outerWidth() 

  ##### create canvas and context

  args =
    elem: $('canvas')
    bodyWidth: $('body').width()
    bodyHeight: $('body').height()
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

  ##### create logo

  args =
    elem: $('#logo')
    context: context
    screenWidth: $(window).width()
  logo = new Logo(args)

  ##### animation loop

  animate = ->
    context.clear canvas.width, canvas.height
    for square in squares
      square.draw()
    logo.draw()

    # continue animation
    window.animationId = requestAnimationFrame animate

  ##### handle events

  # squares

  $('.square[data-rollover="true"]').mouseenter ->
    square = findById $(this)
    square.state = 'hover'
    # window.animationId = requestAnimationFrame animate

  $('.square[data-rollover="true"]').mouseleave ->
    square = findById $(this)
    square.state = 'static'
    # cancelAnimationFrame window.animationId

  # logo

  $(document).mousemove (ev) ->
    if logo.full
      logo.animate ev.pageX, ev.pageY
      $(this).mouseleave ->
        logo.reset()

  $('canvas').mousedown (ev) ->
    if logo.isUnderMouse ev.pageX, ev.pageY
      logo.explode ev.pageX, ev.pageY
      $(this).mouseup ->
        if logo.full then logo.contract() else logo.expand()
        $(this).unbind('mouseup')

  ##### resize adjustments

  resizingTimeoutId = undefined

  $(window).resize ->
    # continue if still resizing
    clearTimeout resizingTimeoutId

    if (window.animationId is 0) or (window.animationId is undefined)
      window.animationId = requestAnimationFrame animate

    $('.square').each ->
      $(this).css 'height', $(this).outerWidth()

    canvas.orient $('body').width(), $('body').height()
    context.setMultiply()

    logo.resize $(window).innerWidth()

    for square in squares
      square.orient()

    # haven't resized in 300ms!
    resizingTimeoutId = setTimeout ->
      cancelAnimationFrame window.animationId
      window.animationId = 0
    , 300   