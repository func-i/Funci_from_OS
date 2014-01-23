class @Square
  fillHeight: 0
  fillSpeed: 36

  constructor: (args) ->
    @id         = args.id
    @canvas     = args.canvas
    @context    = args.context
    @ctx        = @context.ctx
    @elem       = args.elem
    @color      = BASE_COLORS[(@elem.data('color'))]
    @type       = @elem.data('type')
    @rollover   = @elem.data('rollover') is 'true'
    @isHalfImage  = @elem.hasClass('half-image')
    @isImage      = @elem.hasClass('image')
    @orient()
    @elem       = @elem.data 'obj', this
    @canvas.squares.push this

  orient: ->
    @sideLength = Math.round @elem.width()
    @top        = Math.round(@elem.offset().top) - @canvas.offsetTop
    @left       = Math.round(@elem.offset().left) - @canvas.offsetLeft
    @orientHalfImage() if @isHalfImage
    @orientImage() if @isImage

  orientHalfImage: ->
    @elem.find('img').css('width', (@elem.width() - 2))

  orientImage: ->
    console.log @elem.width()
    @elem.find('img').css('width', (@elem.width() - 3))

  draw: ->
    if @type is "outlined"
      @strokeRect()
    else if @type is "filled"
      @fillRect()

  strokeRect: (color) ->
    color = color || @color
    @ctx.lineWidth = "1"
    @ctx.strokeStyle = color
    @ctx.strokeRect((@left+.5), (@top+.5), (@sideLength), (@sideLength))

  fillRect: (color) ->
    color = color || @color
    @ctx.fillStyle = color
    @ctx.fillRect(@left, @top, @sideLength, @sideLength)