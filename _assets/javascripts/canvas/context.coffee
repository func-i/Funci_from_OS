class @Context
  constructor: (canvas) ->
    @canvasElem = canvas.elem[0]
    @width      = canvas.width
    @height     = canvas.height
    @pixelRatio = canvas.pixelRatio
    @getCtx()
    @setMultiply()

  getCtx: ->
    @ctx = @canvasElem.getContext "2d"

  setMultiply: ->
    @ctx.setTransform @pixelRatio, 0, 0, @pixelRatio, 0, 0
    @ctx.globalCompositeOperation = 'multiply'

  clear: (canvasWidth, canvasHeight) ->
    @ctx.setTransform @pixelRatio, 0, 0, @pixelRatio, 0, 0
    @ctx.clearRect 0, 0, canvasWidth, canvasHeight