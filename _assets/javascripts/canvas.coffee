##### requestAnimationFrame polyfill
(->
  lastTime = 0
  vendors = ["ms", "moz", "webkit", "o"]
  i = 0

  while i < vendors.length and not window.requestAnimationFrame
    window.requestAnimationFrame = window[vendors[i] + "RequestAnimationFrame"]
    window.cancelAnimationFrame = window[vendors[i] + "CancelAnimationFrame"] or window[vendors[x] + "CancelRequestAnimationFrame"]
    ++i
  unless window.requestAnimationFrame
    window.requestAnimationFrame = (callback, element) ->
      currTime = new Date().getTime()
      timeToCall = Math.max(0, 16 - (currTime - lastTime))
      id = window.setTimeout ->
        callback currTime + timeToCall
      timeToCall
      lastTime = currTime + timeToCall
      id
  unless window.cancelAnimationFrame
    window.cancelAnimationFrame = (id) ->
      clearTimeout id
)()

@squares = []
@logoLetters = []
@LOGO_STRING = "FUNCTIONALIMPERATIVE"

class Canvas
  constructor: (args) ->
    @elem       = args.elem
    @pixelRatio = @getPixelRatio()
    @orient args.bodyWidth, args.bodyHeight

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

class Context
  constructor: (canvas) ->
    @canvasElem = canvas.elem[0]
    @width      = canvas.width
    @height     = canvas.height
    @pixelRatio = canvas.pixelRatio
    @getCtx()
    @setMultiply()

  getCtx: ->
    @ctx = @canvasElem.getContext "2d"

  setMultiply: ->
    @ctx.setTransform @pixelRatio, 0, 0, @pixelRatio, 0, 0
    @ctx.globalCompositeOperation = 'multiply'

  clear: (canvasWidth, canvasHeight) ->
    @ctx.setTransform @pixelRatio, 0, 0, @pixelRatio, 0, 0
    @ctx.clearRect 0, 0, canvasWidth, canvasHeight

class LogoLetter
  spriteSideLength: 120
  spritePadding: 4
  xOverlap: 5
  yOverlap: 12
  mousemoveEffectDistance: 100

  constructor: (args) ->
    @id            = args.id
    @ctx           = args.context.ctx
    @text          = args.text
    @anchorLeft    = args.anchor.left
    @anchorTop     = args.anchor.top
    @logoImgObject = args.logoImgObject
    @pixelRatio    = args.context.pixelRatio
    @sideLength    = @spriteSideLength / 2

    @setWord()
    @setColor()
    @setHomePosition()
    @draw()

    logoLetters.push this
    this
    
  setWord: ->
    @word = if @id < 10 then 1 else 2

  setColor: ->
    colorString = if @word is 1 then "yellow" else "blue"
    @color = BASE_COLORS[colorString]

  setHomePosition: ->
    mult = if @word is 1 then @id else @id - 10
    leftOffset = (mult * @sideLength) - (mult * @xOverlap)
    @homeLeft = @anchorLeft + leftOffset
    @left = @homeLeft

    topOffset = if @word is 1 then 0 else @sideLength - @yOverlap
    @homeTop = @anchorTop + topOffset
    @top = @homeTop

  reset: ->
    @left = @homeLeft
    @top = @homeTop

  draw: ->
    ySpriteOffset = @id * (@spriteSideLength + @spritePadding)
    @ctx.drawImage @logoImgObject, 0, ySpriteOffset, @spriteSideLength, @spriteSideLength, @left, @top, @sideLength, @sideLength

  getDistanceFromMouse: (mouseLeft, mouseTop) ->
    middleLeft = @left + (@sideLength / 2)
    middleTop = @top + (@sideLength / 2)

    distanceFromMouse = {}
    distanceFromMouse.left = mouseLeft - middleLeft
    distanceFromMouse.top = mouseTop - middleTop
    return distanceFromMouse

  moveFromMouse: (distanceFromMouse) ->
    radialDistanceFromMouse = Math.round(Math.sqrt(Math.pow(distanceFromMouse.left, 2) + Math.pow(distanceFromMouse.top, 2)))
    if (radialDistanceFromMouse <= @mousemoveEffectDistance)
      mult = (@mousemoveEffectDistance - radialDistanceFromMouse) / @mousemoveEffectDistance
      @left = Math.round(@homeLeft - (distanceFromMouse.left * mult))
      @top = Math.round(@homeTop - (distanceFromMouse.top * mult))
    else
      @reset()

class Square
  fillHeight: 0
  fillSpeed: 16

  constructor: (args) ->
    @id         = args.id
    @ctx        = args.context.ctx
    @elem       = args.elem
    @color      = BASE_COLORS[(@elem.data('color'))]
    @type       = @elem.data('type')
    @rollover   = @elem.data('rollover') is 'true'
    @state      = 'static'
    @orient()
    squares.push this
    this

  orient: ->
    @sideLength = @elem.outerWidth()
    @top        = @elem.offset().top
    @left       = @elem.offset().left

  draw: ->
    if @type is 'outlined'
      if @state is 'static'
        @fillHeight = 0
        @ctx.lineWidth = "1"
        @ctx.strokeStyle = @color
        @ctx.strokeRect @left, @top, @sideLength, @sideLength 
      if @state is 'hover'
        # draw border
        @ctx.lineWidth = "1"
        @ctx.strokeStyle = @color
        @ctx.strokeRect @left, @top, @sideLength, (@sideLength + @newFillHeight())
        # draw filled box
        @ctx.fillStyle = @color
        @ctx.fillRect @left, (@top + @sideLength), @sideLength, @newFillHeight()

  newFillHeight: ->
    if @fillHeight > -@sideLength
      @fillHeight -= @fillSpeed
    else
      @fillHeight = -@sideLength

findById = (elem) ->
  id = elem.data('id')
  square = _.findWhere squares, id: id

animate = (args) ->
  canvas  = args.canvas
  context = args.context

  context.clear canvas.width, canvas.height
  for square in squares
    square.draw()
  for logoLetter in logoLetters
    logoLetter.draw()

  # continue animation
  requestAnimationFrame ->
    args =
      canvas: canvas
      context: context
    animate(args)

$ ->
  ##### make squares square
  $('.square').each ->
    width = $(this).outerWidth()
    $(this).css 'height', width 

  ##### create Canvas object
  args =
    elem: $('canvas')
    bodyWidth: $('body').width()
    bodyHeight: $('body').height()
  canvas = new Canvas(args)
  context = new Context(canvas)

  ##### create logo
  logoPosition = $('#logo').offset()
  logoSrc = $('#logo').data('imgSrc')

  logoImgObject = new Image()
  logoImgObject.src = logoSrc

  # wait for image to load
  logoImgObject.onload = ->
    # loop through letters
    for index in [0..(LOGO_STRING.length-1)]
      args =
        text: LOGO_STRING.charAt(index)
        anchor: logoPosition
        logoImgObject: logoImgObject
        context: context
        id: index
      logoLetter = new LogoLetter(args)

  ##### find and create Square objects
  $('.square').each (index) ->
    args =
      elem: $(this)
      context: context
      id: index
    square = new Square(args)
    $(this).data 'id', index
    square.draw()

  animationId = requestAnimationFrame ->
    args =
      canvas: canvas
      context: context
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
    for logoLetter in logoLetters
      distanceFromMouse = logoLetter.getDistanceFromMouse ev.pageX, ev.pageY
      logoLetter.moveFromMouse distanceFromMouse
  .mouseleave ->
    for logoLetter in logoLetters
      logoLetter.reset()

  $(window).resize ->
    $('.square').each ->
      width = $(this).outerWidth()
      $(this).css 'height', width 
    canvas.orient $('body').width(), $('body').height()
    context.setMultiply()
    for square in squares
      square.orient()