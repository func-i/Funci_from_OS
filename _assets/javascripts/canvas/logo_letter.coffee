class @LogoLetter
  spriteSideLength: 120
  spritePadding: 4
  defaultSideLength:
    large: 60
    small: 35
  xOverlap:
    large: 5
    small: 3
  yOverlap:
    large: 12
    small: 6
  mousemoveEffectDistance:
    large: 100
    small: 75
  expansionSize:
    large: 4
    small: 8

  constructor: (args) ->
    @id            = args.id
    @ctx           = args.context.ctx
    @text          = args.text
    @anchorLeft    = args.anchor.left
    @anchorTop     = args.anchor.top
    @logo          = args.logo
    @display       = args.display
    @logoImgObject = args.logoImgObject
    @pixelRatio    = args.context.pixelRatio
    @ySpriteOffset = @id * (@spriteSideLength + @spritePadding)
    @expanded      = false
    @setSideLength()
    @setWord()
    @setColor()
    @setHomePosition()

  setSideLength: (sideLength) ->
    @sideLength = sideLength || @defaultSideLength[@logo.size]

  middle: ->
    left = @left + (@sideLength / 2)
    top  = @top + (@sideLength / 2)
    return { left: left, top: top }

  setFromMiddle: (middleLeft, middleTop) ->
    @left = middleLeft - (@sideLength / 2)
    @top  = middleTop - (@sideLength / 2)

  setWord: ->
    @word = if @id < 10 then 1 else 2

  setColor: ->
    colorString = if @word is 1 then "yellow" else "blue"
    @color = BASE_COLORS[colorString]

  setHomePosition: ->
    mult = if @word is 1 then @id else @id - 10
    leftOffset = (mult * @sideLength) - (mult * @xOverlap[@logo.size])
    @homeLeft = @anchorLeft + leftOffset
    @initHomeLeft = @homeLeft

    topOffset = if @word is 1 then 0 else @sideLength - @yOverlap[@logo.size]
    @homeTop = @anchorTop + topOffset
    @initHomeTop = @homeTop

    @returnHome()

  returnHome: ->
    @left = @homeLeft
    @top = @homeTop

  reset: ->
    @left = @homeLeft = @initHomeLeft
    @top = @homeTop = @initHomeTop

  isVisible: ->
    (@id is 0 or @id is 10) or @logo.expanded

  draw: ->
    @ctx.drawImage(@logoImgObject, 0, @ySpriteOffset, @spriteSideLength, @spriteSideLength, @left, @top, @sideLength, @sideLength) if @isVisible()

  getDistanceFromMouse: (mouseLeft, mouseTop) ->
    distanceFromMouse =
      left: mouseLeft - @middle().left
      top: mouseTop - @middle().top
    return distanceFromMouse

  moveFromMouse: (args) ->
    distanceFromMouse = args.distanceFromMouse
    mousemoveEffectDistance = args.mousemoveEffectDistance || @mousemoveEffectDistance[@logo.size]

    radialDistanceFromMouse = Math.round(Math.sqrt(Math.pow(distanceFromMouse.left, 2) + Math.pow(distanceFromMouse.top, 2)))
    if (radialDistanceFromMouse <= mousemoveEffectDistance)
      mult = (mousemoveEffectDistance - radialDistanceFromMouse) / mousemoveEffectDistance
      @left = Math.round(@homeLeft - (distanceFromMouse.left * mult))
      @top = Math.round(@homeTop - (distanceFromMouse.top * mult))
    else
      @returnHome()

  squeeze: (pinch) ->
    diffX = pinch.center.pageX - @middle().left
    diffY = pinch.center.pageY - @middle().top

    middleLeft = Math.round(@middle().left + (diffX * pinch.multiplier()))
    middleTop = Math.round(@middle().top + (diffY * pinch.multiplier()))

    @setFromMiddle middleLeft, middleTop

  isUnderMouse: (mouseLeft, mouseTop) ->
    underX = mouseLeft > @left and mouseLeft < (@left + @sideLength)
    underY = mouseTop > @top and mouseTop < (@top + @sideLength)
    return (underX and underY)

  expand: ->
    @sideLength = @sideLength + (@expansionSize[@logo.size] * 2)
    @left = @left - @expansionSize[@logo.size]
    @top = @top - @expansionSize[@logo.size]

  contract: ->
    @left = @left + @expansionSize[@logo.size]
    @top = @top + @expansionSize[@logo.size]
    @sideLength = @sideLength - (@expansionSize[@logo.size] * 2)

  stickToTouch: (mouseLeft, mouseTop) ->
    @left = mouseLeft + @holdOffset.left
    @top  = mouseTop + @holdOffset.top

  savePos: ->
    @homeLeft = @left
    @homeTop = @top