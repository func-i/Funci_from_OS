class @Square
  fillHeight: 0
  fillSpeed: 36

  constructor: (args) ->
    @id         = args.id
    @context    = args.context
    @ctx        = @context.ctx
    @elem       = args.elem
    @color      = BASE_COLORS[(@elem.data('color'))]
    @type       = @elem.data('type')
    @rollover   = @elem.data('rollover') is 'true'
    @orient()
    squares.push this
    this

  orient: ->
    @sideLength = @elem.outerWidth()
    @top        = @elem.offset().top
    @left       = @elem.offset().left

  draw: ->
    if @type is "outlined"
      @strokeRect()
    else if @type is "filled"
      @fillRect()

  strokeRect: (color) ->
    color = color || @color
    @ctx.lineWidth = "1"
    @ctx.strokeStyle = color
    @ctx.strokeRect @left, @top, @sideLength, @sideLength

  fillRect: (color) ->
    color = color || @color
    @ctx.fillStyle = color
    @ctx.fillRect @left, @top, @sideLength, @sideLength