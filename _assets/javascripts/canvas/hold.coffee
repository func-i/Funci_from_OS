class @Hold
  constructor: (args) ->
    @logo          = args.logo
    @initMouseLeft = args.mouseX
    @initMouseTop  = args.mouseY
    @heldLetters   = []
    @findHeldLetters()
    @expandHeldLetters()
    @setHoldOffset()

  findHeldLetters: ->
    for logoLetter in @logo.logoLetters
      @heldLetters.push(logoLetter) if logoLetter.isUnderMouse @initMouseLeft, @initMouseTop
    @heldLetters

  setHoldOffset: ->
    for heldLetter in @heldLetters
      heldLetter.holdOffset =
        left: heldLetter.left - @initMouseLeft
        top: heldLetter.top - @initMouseTop

  expandHeldLetters: ->
    for heldLetter in @heldLetters
      heldLetter.expand()

  end: ->
    for heldLetter in @heldLetters
      heldLetter.contract()
      heldLetter.savePos()