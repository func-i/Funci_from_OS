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
    if @screenWidth >= @breakPoint.large
      @size = "large"
    else if @screenWidth >= @breakPoint.small
      @size = "small"
    else
      @size = "twoLetters"

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
    topLetter = _.min @logoLetters, (logoLetter) -> logoLetter.homeTop
    rightLetter = _.max @logoLetters, (logoLetter) -> logoLetter.homeLeft
    bottomLetter = _.max @logoLetters, (logoLetter) -> logoLetter.homeTop
    leftLetter = _.min @logoLetters, (logoLetter) -> logoLetter.homeLeft

    top = topLetter.top
    right = rightLetter.left + rightLetter.sideLength[@size]
    bottom = bottomLetter.top + bottomLetter.sideLength[@size]
    left = leftLetter.left

    return (mouseLeft < right and mouseLeft > left and mouseTop < bottom and mouseTop > top)

  resize: (screenWidth) ->
    @screenWidth = screenWidth
    @setSize()
    @setHomePosition()

  changeCursor: (mouseLeft, mouseTop) ->
    if @isUnderMouse mouseLeft, mouseTop
      @elem.css 'cursor', 'pointer'
    else
      @elem.css 'cursor', 'default'

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