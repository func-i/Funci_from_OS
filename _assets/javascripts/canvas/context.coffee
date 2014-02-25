class @Context
  clearBuffer: 1

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

  clear: (offsetX, offsetY, width, height) ->
    @ctx.setTransform @pixelRatio, 0, 0, @pixelRatio, 0, 0
    @ctx.clearRect (offsetX), (offsetY), (width + @clearBuffer), (height + @clearBuffer)