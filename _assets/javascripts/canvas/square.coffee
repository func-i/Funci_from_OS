class @Square
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

  newFillHeight: ->
    if @fillHeight > -@sideLength
      @fillHeight -= @fillSpeed
    else
      @fillHeight = -@sideLength

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