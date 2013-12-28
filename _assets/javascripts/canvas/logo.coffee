class @Logo
  logoString: "FUNCTIONALIMPERATIVE"
  logoLetters: []
  breakPoint: 640

  constructor: (args) ->
    @elem            = args.elem
    @context         = args.context
    @initScreenWidth = args.screenWidth
    @position        = @elem.offset()
    @imgSrc          = @elem.data('imgSrc')
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
    @setSizeByScreen @initScreenWidth
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

  setSizeByScreen: (screenWidth) ->
    @full = (screenWidth >= @breakPoint)
    if @full then @expand() else @contract()

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
    @reset()

  contract: ->
    for logoLetter in @logoLetters
      logoLetter.display = (logoLetter.id is 0 or logoLetter.id is 10)
    @full = false
    @reset()

  reset: ->
    for logoLetter in @logoLetters
      logoLetter.reset()

  draw: ->
    for logoLetter in @logoLetters
      logoLetter.draw() if logoLetter.display