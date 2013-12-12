class Canvas
  constructor: (args) ->
    @elem = args.elem

  pixelRatio: ->
    testCtx = @elem[0].getContext('2d')
    dpr = window.devicePixelRatio or 1
    bspr = testCtx.webkitBackingStorePixelRatio or testCtx.mozBackingStorePixelRatio or testCtx.msBackingStorePixelRatio or testCtx.oBackingStorePixelRatio or testCtx.backingStorePixelRatio or 1
    dpr / bspr

  create: (width, height) ->
    pixelRatio = @pixelRatio()
    @elem.attr 'width', (width * pixelRatio)
    @elem.attr 'height', (height * pixelRatio)
    ctx = @elem[0].getContext("2d")
    ctx.setTransform pixelRatio, 0, 0, pixelRatio, 0, 0
    ctx.globalCompositeOperation = 'multiply'
    ctx

class Square
  constructor: (args) ->
    @sideLength = args.elem.outerHeight()
    @left       = args.elem.offset().left
    @top        = args.elem.offset().top
    @color      = BASE_COLORS[(args.elem.data('color'))]
    @type       = args.elem.data('type')
    @ctx        = args.ctx

  init: ->
    @ctx.save()
    @ctx.lineWidth = "1"
    @ctx.strokeStyle = @color
    @ctx.strokeRect(@left, @top, @sideLength, @sideLength)
    @ctx.restore()

  fillUp: ->
    @ctx.save()
    @ctx.fillStyle = @color
    @ctx.fillRect(@left, @top, @sideLength, @sideLength)
    @ctx.restore()

$ ->
  width   = $('body').width()
  height  = $('body').height()

  canvas = new Canvas({elem: $('canvas')})
  ctx    = canvas.create(width, height)

  $('.square').each ->
    args =
      elem: $(this)
      ctx:  ctx
    square = new Square(args)
    square.init()

  $('.square').click ->
    args =
      elem: $(this)
      ctx:  ctx
    square = new Square(args)
    square.fillUp()