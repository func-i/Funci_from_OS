@squares = []

class Canvas
  constructor: (args) ->
    @elem       = args.elem
    @width      = args.bodyWidth
    @height     = args.bodyHeight
    @pixelRatio = @getPixelRatio()
    @orient @width, @height
    @setupCtx()

  getPixelRatio: ->
    testCtx = @elem[0].getContext('2d')
    dpr = window.devicePixelRatio or 1
    bspr = testCtx.webkitBackingStorePixelRatio or testCtx.mozBackingStorePixelRatio or testCtx.msBackingStorePixelRatio or testCtx.oBackingStorePixelRatio or testCtx.backingStorePixelRatio or 1
    dpr / bspr

  orient: (bodyWidth, bodyHeight) ->
    @width  = bodyWidth
    @height = bodyHeight
    @elem.attr 'width', (@width * @pixelRatio) 
    @elem.attr 'height', (@height * @pixelRatio) 

  setupCtx: ->
    @ctx = @elem[0].getContext("2d")
    @ctx.setTransform @pixelRatio, 0, 0, @pixelRatio, 0, 0
    @ctx.globalCompositeOperation = 'multiply'

  clear: ->
    @ctx.save()
    @ctx.setTransform @pixelRatio, 0, 0, @pixelRatio, 0, 0
    @ctx.clearRect 0, 0, @width, @height
    @ctx.restore()

class Square
  constructor: (args) ->
    @id         = args.id
    @ctx        = args.ctx
    @elem       = args.elem
    @state      = 'static'
    @fillHeight = 0
    @fillSpeed  = 32
    @orient()
    squares.push this
    this

  orient: () ->
    @sideLength = @elem.outerHeight()
    @top        = @elem.offset().top
    @left       = @elem.offset().left
    @color      = BASE_COLORS[(@elem.data('color'))]
    @type       = @elem.data('type')

  draw: ->
    if @type is 'outlined'
      if @state is 'static'
        @fillHeight = 0
        @ctx.save()
        @ctx.lineWidth = "1"
        @ctx.strokeStyle = @color
        @ctx.strokeRect @left, @top, @sideLength, @sideLength 
        @ctx.restore()
      if @state is 'hover'
        @ctx.save()
        @ctx.strokeStyle = @color
        @ctx.strokeRect @left, @top, @sideLength, (@sideLength + @newFillHeight())
        @ctx.fillStyle = @color
        @ctx.fillRect @left, (@top + @sideLength), @sideLength, @newFillHeight()
        @ctx.restore()


  newFillHeight: ->
    if @fillHeight > -@sideLength
      @fillHeight -= @fillSpeed
    else
      @fillHeight = -@sideLength

animate = (args) ->
  canvas = args.canvas
  canvas.clear()
  for square in squares
    square.draw()
  # continue animation
  requestAnimationFrame ->
    animate(canvas: canvas)

findById = (elem) ->
  id = elem.data('id')
  square = _.findWhere squares, id: id

$ -> 

  # create Canvas object
  args =
    elem: $('canvas')
    bodyWidth: $('body').width()
    bodyHeight: $('body').height()
  canvas = new Canvas(args)

  # find and create Square objects
  $('.square').each (index) ->
    args =
      elem: $(this)
      ctx: canvas.ctx
      id: index
    square = new Square(args)
    $(this).data 'id', index
    square.draw()

  $('.square').mouseenter ->
    square = findById $(this)
    square.state = 'hover'

  $('.square').mouseleave ->
    square = findById $(this)
    square.state = 'static'


  # start animating
  animationId = requestAnimationFrame ->
    animate(canvas: canvas)

  $(window).resize ->
    canvas.orient $('body').width(), $('body').height()
    canvas.setupCtx()
    for square in squares
      square.orient()




      