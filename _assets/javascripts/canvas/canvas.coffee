class @Canvas
  constructor: (args) ->
    @elem       = args.elem
    @pixelRatio = @getPixelRatio()
    @orient args.bodyWidth, args.bodyHeight

  getPixelRatio: ->
    testCtx = @elem[0].getContext('2d')
    dpr = window.devicePixelRatio or 1
    bspr = testCtx.webkitBackingStorePixelRatio or testCtx.mozBackingStorePixelRatio or testCtx.msBackingStorePixelRatio or testCtx.oBackingStorePixelRatio or testCtx.backingStorePixelRatio or 1
    dpr / bspr

  orient: (bodyWidth, bodyHeight) ->
    @width  = bodyWidth
    @height = bodyHeight
    @elem.attr 'width', (@width * @pixelRatio) 
    @elem.attr 'height', (@height * @pixelRatio) 