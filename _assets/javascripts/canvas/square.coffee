class @Square
  fillHeight: 0
  fillSpeed: 36

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

  setFillHeight: ->
    if (@fillHeight < @sideLength) and ((@sideLength - @fillHeight) >= @fillSpeed)
      @fillHeight += @fillSpeed
    else
      @fillHeight = @sideLength

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
        @ctx.strokeRect @left, @top, @sideLength, (@sideLength - @fillHeight)
        # draw filled box
        @ctx.fillStyle = @color
        fluidOffsetY = @top + @sideLength - @fillHeight
        @ctx.fillRect @left, fluidOffsetY, @sideLength, @fillHeight
        @setFillHeight()