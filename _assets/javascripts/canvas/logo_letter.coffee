class @LogoLetter
  spriteSideLength: 120
  spritePadding: 4
  xOverlap: 5
  yOverlap: 12
  mousemoveEffectDistance: 100
  expansionSize: 4

  constructor: (args) ->
    @id            = args.id
    @ctx           = args.context.ctx
    @text          = args.text
    @anchorLeft    = args.anchor.left
    @anchorTop     = args.anchor.top
    @display       = args.display
    @logoImgObject = args.logoImgObject
    @pixelRatio    = args.context.pixelRatio
    @sideLength    = @spriteSideLength / 2
    @setWord()
    @setColor()
    @setHomePosition()

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
    distanceFromMouse = {}
    distanceFromMouse.left = mouseLeft - @middle().left
    distanceFromMouse.top = mouseTop - @middle().top
    return distanceFromMouse

  moveFromMouse: (args) ->
    distanceFromMouse = args.distanceFromMouse
    mousemoveEffectDistance = args.mousemoveEffectDistance || @mousemoveEffectDistance

    radialDistanceFromMouse = Math.round(Math.sqrt(Math.pow(distanceFromMouse.left, 2) + Math.pow(distanceFromMouse.top, 2)))
    if (radialDistanceFromMouse <= mousemoveEffectDistance)
      mult = (mousemoveEffectDistance - radialDistanceFromMouse) / mousemoveEffectDistance
      @left = Math.round(@homeLeft - (distanceFromMouse.left * mult))
      @top = Math.round(@homeTop - (distanceFromMouse.top * mult))
    else
      @reset()

  squeeze: (pinch) ->
    diffX = pinch.center.pageX - @middle().left
    diffY = pinch.center.pageY - @middle().top

    middleLeft = Math.round(@middle().left + (diffX * pinch.multiplier()))
    middleTop = Math.round(@middle().top + (diffY * pinch.multiplier()))

    console.log diffX, middleLeft, diffY, middleTop

    @setFromMiddle middleLeft, middleTop

  isUnderMouse: (mouseLeft, mouseTop) ->
    underX = mouseLeft > @left and mouseLeft < (@left + @sideLength)
    underY = mouseTop > @top and mouseTop < (@top + @sideLength)
    return (underX and underY)

  expand: ->
    @sideLength = @sideLength + (@expansionSize * 2)
    @left = @left - @expansionSize
    @top = @top - @expansionSize

  contract: ->
    @left = @left + @expansionSize
    @top = @top + @expansionSize
    @sideLength = @sideLength - (@expansionSize * 2)

  stickToTouch: (mouseLeft, mouseTop) ->
    @left = mouseLeft + @holdOffset.left
    @top  = mouseTop + @holdOffset.top
    @savePos()

  savePos: ->
    @homeLeft = @left
    @homeTop = @top











