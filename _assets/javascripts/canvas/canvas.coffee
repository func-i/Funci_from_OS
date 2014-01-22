class @Canvas
  buffer: 4

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
    @offsetLeft = Math.round @referenceElem.offset().left - (@buffer - @buffer/2)
    @offsetTop  = Math.round @referenceElem.offset().top - (@buffer - @buffer/2)

  orient: ->
    @setOffset()

    @width  = @referenceElem.width() + @buffer
    @height = @referenceElem.height() + @buffer

    @elem.css 'width', (@width)
    @elem.css 'height', (@height)

    @elem.attr 'width', (@width * @pixelRatio) 
    @elem.attr 'height', (@height * @pixelRatio)