class @Canvas
  buffer: 2

  constructor: (args) ->
    @referenceElem = args.referenceElem
    @createElem()
    @setOffset()
    @pixelRatio = @getPixelRatio()
    @orient()
    @elem.data 'obj', this
    @squares = []

  createElem: ->
    @elem = $('<canvas></canvas>')
    @referenceElem.prepend @elem

  getPixelRatio: ->
    testCtx = @elem[0].getContext('2d')
    dpr = window.devicePixelRatio or 1
    bspr = testCtx.webkitBackingStorePixelRatio or testCtx.mozBackingStorePixelRatio or testCtx.msBackingStorePixelRatio or testCtx.oBackingStorePixelRatio or testCtx.backingStorePixelRatio or 1
    dpr / bspr

  setOffset: ->
    @offsetLeft = Math.round @referenceElem.offset().left - @buffer
    @offsetTop  = Math.round @referenceElem.offset().top - @buffer

  orient: ->
    @setOffset()

    @width  = @referenceElem.width() + (@buffer * 2)
    @height = @referenceElem.height() + (@buffer * 2)

    @elem.css 'width', (@width)
    @elem.css 'height', (@height)

    @elem.attr 'width', (@width * @pixelRatio) 
    @elem.attr 'height', (@height * @pixelRatio)

  adjustSquarePositions: ->
    for currentSquare, i in @squares
      for otherSquare in @squares.slice (i+1), @squares.length
        currentSquareRight = currentSquare.left + currentSquare.sideLength
        if otherSquare.left is (currentSquareRight + 1)
          otherSquare.left -= 1
          otherSquare.elem.css 'left', -1
          otherSquare.alreadyAdjusted = true
        else if otherSquare.left is (currentSquareRight - 1)
          otherSquare.left += 1
          otherSquare.elem.css 'left', 1
          otherSquare.alreadyAdjusted = true
        else if otherSquare.left is (currentSquareRight + 2)
          otherSquare.left -= 2
          otherSquare.elem.css 'left', -2
          otherSquare.alreadyAdjusted = true
        else
          otherSquare.elem.css 'left', 0 unless otherSquare.alreadyAdjusted