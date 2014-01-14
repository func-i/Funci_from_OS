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
    @state      = 'static'
    @orient()
    squares.push this
    this

  orient: ->
    @sideLength = @elem.outerWidth()
    @top        = @elem.offset().top
    @left       = @elem.offset().left

  draw: ->
    @strokeRect()

  strokeRect: (color) ->
    color = color || @color
    @ctx.lineWidth = "1"
    @ctx.strokeStyle = color
    @ctx.strokeRect @left, @top, @sideLength, @sideLength