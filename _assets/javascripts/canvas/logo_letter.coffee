class @LogoLetter
  LETTERS_IN_WORD = 10
  NUMBER_OF_WORDS = 2
  spriteSideLength: 120
  spritePadding: 4
  xOverlapPercentage: 8.5
  yOverlapPercentage: 16
  mouseMoveEffectDistanceFactor: 1.7
  expansionSize:
    large: 4
    small: 8

  constructor: (args) ->
    @id            = args.id
    @ctx           = args.context.ctx
    @text          = args.text
    @anchor        = args.anchor
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
    @left = @homeLeft
    @top = @homeTop

  setSideLength: (sideLength) ->
    sideLengthFromHorizontalAxis = @calculateSideLengths(
      @logo.elem.width(),
      @xOverlapPercentage,
      LETTERS_IN_WORD
    )
    sideLengthFromVerticalAxis = @calculateSideLengths(
      @logo.elem.height(),
      1/2 * @yOverlapPercentage,
      NUMBER_OF_WORDS
    )
    @sideLength = Math.min(sideLengthFromVerticalAxis, sideLengthFromHorizontalAxis)

  calculateSideLengths: (canonicalLength, overlapPercentage, numberOfLetters) ->
    totalOverlap = canonicalLength * (0.01 * overlapPercentage)
    Math.floor((canonicalLength +  totalOverlap) / (numberOfLetters))

  calculateOverlap: (overlapPercentage) ->
    (0.01 * overlapPercentage * @sideLength)

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
    mult = if @word is 1 then @id else @id - LETTERS_IN_WORD
    leftOffset = (mult * @sideLength) - (mult * @calculateOverlap(@xOverlapPercentage))
    @homeLeft = @anchor.left + leftOffset
    @initHomeLeft = @homeLeft

    topOffset = if @word is 1 then 0 else @sideLength - @calculateOverlap(@yOverlapPercentage)
    @homeTop = @anchor.top + topOffset
    @initHomeTop = @homeTop

    @returnHome()

  returnHome: ->
    # horizontalDifference = @left - @homeLeft
    # verticalDifference = @top - @homeTop
    # horizontalDirection = Math.sign(horizontalDifference)
    # verticalDirection = Math.sign(verticalDifference)
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
    mouseMoveEffectDistance = @mouseMoveEffectDistanceFactor * @sideLength
    radialDistanceFromMouse = Math.round(Math.sqrt(Math.pow(distanceFromMouse.left, 2) + Math.pow(distanceFromMouse.top, 2)))
    if (radialDistanceFromMouse <= mouseMoveEffectDistance)
      mult = (mouseMoveEffectDistance - radialDistanceFromMouse) / mouseMoveEffectDistance
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
