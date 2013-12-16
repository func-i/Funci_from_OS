@squares = []

class Canvas
  constructor: (args) ->
    @elem       = args.elem
    @pixelRatio = @getPixelRatio()
    @width      = args.bodyWidth
    @height     = args.bodyHeight
    @setDimensions @width, @height
    @setupCtx()

  getPixelRatio: ->
    testCtx = @elem[0].getContext('2d')
    dpr = window.devicePixelRatio or 1
    bspr = testCtx.webkitBackingStorePixelRatio or testCtx.mozBackingStorePixelRatio or testCtx.msBackingStorePixelRatio or testCtx.oBackingStorePixelRatio or testCtx.backingStorePixelRatio or 1
    dpr / bspr

  setDimensions: (bodyWidth, bodyHeight) ->
    @width  = bodyWidth
    @height = bodyHeight
    @elem.attr 'width', (bodyWidth * @pixelRatio) 
    @elem.attr 'height', (bodyHeight * @pixelRatio) 

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
    @id    = args.id
    @ctx   = args.ctx
    @state = 'static'
    @getProperties args
    squares.push this
    this

  getProperties: (args) ->
    @sideLength = args.elem.outerHeight()
    @top        = args.elem.offset().top
    @left       = args.elem.offset().left
    @color      = BASE_COLORS[(args.elem.data('color'))]
    @type       = args.elem.data('type')

  draw: ->
    if @type is 'outlined'
      if @state is 'static'
        @ctx.save()
        @ctx.lineWidth = "1"
        @ctx.strokeStyle = @color
        @ctx.strokeRect @left, @top, @sideLength, @sideLength 
        @ctx.restore()
      if @state is 'hover'
        @ctx.save()
        @ctx.fillStyle = @color
        @ctx.fillRect @left, @top, @sideLength, @sideLength 
        @ctx.restore()

animate = (args) ->
  canvas = args.canvas
  canvas.clear()
  for square in squares
    square.draw()
  requestAnimationFrame ->
    animate(canvas: canvas)

findById = (elem) ->
  id = elem.data('id')
  square = _.findWhere squares, id: id

$ -> 
  args =
    elem: $('canvas')
    bodyWidth: $('body').width()
    bodyHeight: $('body').height()
  canvas = new Canvas(args)

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
    
  animationId = requestAnimationFrame ->
    animate(canvas: canvas)