class @Logo
  logoString: "FUNCTIONALIMPERATIVE"
  logoLetters: []
  breakPoint: 640

  constructor: (args) ->
    @elem            = args.elem
    @canvas          = args.canvas
    @context         = args.context
    @initScreenWidth = args.screenWidth
    @position        = @elem.offset()
    @imgSrc          = @elem.data('imgSprite')
    @setImg()
    # createLogo() after img is loaded

  setImg: () ->
    logo = this
    @imgObject = new Image()
    @imgObject.src = @imgSrc
    @imgObject.onload = ->
      logo.createLogo()

  createLogo: ->
    @createSquares()
    @initSize @initScreenWidth
    @draw()

  createSquares: ->
    for index in [0..(@logoString.length-1)]
      args =
        text: @logoString.charAt(index)
        anchor: @position
        logoImgObject: @imgObject
        context: @context
        id: index
      logoLetter = new LogoLetter(args)
      @logoLetters.push logoLetter

  isUnderMouse: (mouseLeft, mouseTop) ->
    topLetter = _.min @logoLetters, (logoLetter) ->
      logoLetter.homeTop if logoLetter.display
    rightLetter = _.max @logoLetters, (logoLetter) ->
      logoLetter.homeLeft if logoLetter.display
    bottomLetter = _.max @logoLetters, (logoLetter) ->
      logoLetter.homeTop if logoLetter.display
    leftLetter = _.min @logoLetters, (logoLetter) ->
      logoLetter.homeLeft if logoLetter.display

    top = topLetter.top
    right = rightLetter.left + rightLetter.sideLength
    bottom = bottomLetter.top + bottomLetter.sideLength
    left = leftLetter.left

    return (mouseLeft < right and mouseLeft > left and mouseTop < bottom and mouseTop > top)

  initSize: (screenWidth) ->
    @full = (screenWidth >= @breakPoint)
    if @full then @expand() else @contract()

  resize: (screenWidth) ->
    bigEnough = (screenWidth >= @breakPoint)
    if @full and !bigEnough then @contract()

  changeCursor: (mouseLeft, mouseTop) ->
    if @isUnderMouse mouseLeft, mouseTop
      @elem.css 'cursor', 'pointer'
    else
      @elem.css 'cursor', 'default'

  handleMouseup: (args) ->
    onHome   = args.onHome
    onMobile = args.onMobile
    if !onHome
      window.location.replace "/"
    else
      unless onMobile
        if @full then @contract() else @expand()
        @reset()

  animate: (mouseLeft, mouseTop) ->
    for logoLetter in @logoLetters
      distanceFromMouse = logoLetter.getDistanceFromMouse mouseLeft, mouseTop
      logoLetter.moveFromMouse distanceFromMouse: distanceFromMouse

  explode: (mouseLeft, mouseTop) ->
    for logoLetter in @logoLetters
      logoLetter.display = true
      distanceFromMouse = logoLetter.getDistanceFromMouse mouseLeft, mouseTop
      args =
        distanceFromMouse: distanceFromMouse
        mousemoveEffectDistance: 300
      logoLetter.moveFromMouse args

  expand: ->
    for logoLetter in @logoLetters
      logoLetter.display = true
    @full = true
    @returnHome()

  contract: ->
    for logoLetter in @logoLetters
      logoLetter.display = (logoLetter.id is 0 or logoLetter.id is 10)
    @full = false
    @returnHome()

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
      logoLetter.draw() if logoLetter.display