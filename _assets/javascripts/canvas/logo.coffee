class @Logo
  logoString: "FUNCTIONALIMPERATIVE"
  logoLetters: []
  breakPoint:
    large: 640
    small: 320

  constructor: (args) ->
    @elem            = args.elem
    @canvas          = args.canvas
    @context         = args.context
    @screenWidth     = args.screenWidth
    @position        = @elem.offset()
    @imgSrc          = @elem.data('imgSprite')
    @expanded            = true
    @setSize()
    @setImg()
    # createLogo() after img is loaded

  setSize: ->
    @size = if @screenWidth >= @breakPoint.large then "large" else "small"

  tooDamnSmall: ->
    @screenWidth < @breakPoint.small

  setImg: () ->
    logo = this
    @imgObject = new Image()
    @imgObject.src = @imgSrc
    @imgObject.onload = ->
      logo.createLogo()

  createLogo: ->
    @createSquares()
    @resize @screenWidth
    @draw()

  createSquares: ->
    for index in [0..(@logoString.length-1)]
      args =
        text: @logoString.charAt(index)
        anchor: @position
        logoImgObject: @imgObject
        context: @context
        logo: this
        id: index
      logoLetter = new LogoLetter(args)
      @logoLetters.push logoLetter

  isUnderMouse: (mouseLeft, mouseTop) ->
    topLetter = _.min @logoLetters, (logoLetter) ->
      logoLetter.homeTop if logoLetter.isVisible()
    rightLetter = _.max @logoLetters, (logoLetter) ->
      logoLetter.homeLeft if logoLetter.isVisible()
    bottomLetter = _.max @logoLetters, (logoLetter) ->
      logoLetter.homeTop if logoLetter.isVisible()
    leftLetter = _.min @logoLetters, (logoLetter) ->
      logoLetter.homeLeft if logoLetter.isVisible()

    top = topLetter.top
    right = rightLetter.left + rightLetter.sideLength
    bottom = bottomLetter.top + bottomLetter.sideLength
    left = leftLetter.left

    return (mouseLeft < right and mouseLeft > left and mouseTop < bottom and mouseTop > top)

  resize: (screenWidth) ->
    @screenWidth = screenWidth
    @setSize()
    @setSideLengths()
    @contract() if @tooDamnSmall()
    @setHomePosition()

  changeCursor: (mouseLeft, mouseTop) ->
    cursor = if @isUnderMouse(mouseLeft, mouseTop) then 'pointer' else 'default'
    @elem.css 'cursor', cursor

  animate: (mouseLeft, mouseTop) ->
    for logoLetter in @logoLetters
      distanceFromMouse = logoLetter.getDistanceFromMouse mouseLeft, mouseTop
      logoLetter.moveFromMouse distanceFromMouse: distanceFromMouse

  explode: (mouseLeft, mouseTop) ->
    for logoLetter in @logoLetters
      distanceFromMouse = logoLetter.getDistanceFromMouse mouseLeft, mouseTop
      args =
        distanceFromMouse: distanceFromMouse
        mousemoveEffectDistance: 300
      logoLetter.moveFromMouse args

  expand: ->
    @expanded = true
    @returnHome()

  contract: ->
    @expanded = false
    @returnHome()

  setHomePosition: ->
    for logoLetter in @logoLetters
      logoLetter.setHomePosition()

  setSideLengths: ->
    for logoLetter in @logoLetters
      logoLetter.setSideLength()

  returnHome: ->
    for logoLetter in @logoLetters
      logoLetter.returnHome()

  reset: ->
    for logoLetter in @logoLetters
      logoLetter.reset()

  squeeze: (pinch) ->
    for logoLetter in @logoLetters
      logoLetter.squeeze pinch

  dragLetters: (hold, mouseLeft, mouseTop) ->
    for logoLetter in hold.heldLetters
      logoLetter.stickToTouch mouseLeft, mouseTop

  draw: ->
    for logoLetter in @logoLetters
      logoLetter.draw()