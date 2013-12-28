@squares = []

findById = (elem) ->
  id = elem.data('id')
  square = _.findWhere squares, id: id

animationId = undefined

animate = (args) ->
  canvas  = args.canvas
  context = args.context
  logo    = args.logo

  context.clear canvas.width, canvas.height
  for square in squares
    square.draw()
  logo.draw()

  # continue animation
  requestAnimationFrame ->
    args =
      canvas: canvas
      context: context
      logo: logo
    animate(args) 

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

  animationId = requestAnimationFrame ->
    args =
      canvas: canvas
      context: context
      logo: logo
    animate(args)

  ##### handle events

  # squares

  $('.square[data-rollover="true"]').mouseenter ->
    square = findById $(this)
    square.state = 'hover'

  $('.square[data-rollover="true"]').mouseleave ->
    square = findById $(this)
    square.state = 'static'

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

  $(window).resize ->
    $('.square').each ->
      $(this).css 'height', $(this).outerWidth()

    canvas.orient $('body').width(), $('body').height()
    context.setMultiply()

    logo.resize $(window).innerWidth()

    for square in squares
      square.orient()