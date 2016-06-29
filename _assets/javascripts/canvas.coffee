window.canvases = []
window.logo = {}
@blendingSupported = Modernizr.canvasblending

onHome = ->
  window.location.pathname is "/"

$(window).load ->
  ResizeHelper.handleResize()

##### make square divs square
ResizeHelper.resizeSquares($('.square'))
ResizeHelper.resizeSquares($('.square-no-canvas'))
ResizeHelper.resizeSquares($('.square-no-canvas-no-fill'))

##### create canvases and corresponding contexts
$('.canvas').each (index) ->
  canvas = new Canvas
    referenceElem: $(this)
  context = new Context(canvas)

  canvas.context = context
  window.canvases.push canvas

  ##### create squares
  $('.square', this).each (index) ->
    square = new Square
      elem: $(this)
      canvas: canvas
      context: context
      id: index

  canvas.adjustSquarePositions()

  for square in canvas.squares
    square.draw()

##### handle events

# icon squares
$noTouchIcons = $('.no-touch .square.icon')

unless $noTouchIcons.length is 0
  $noTouchIcons.mouseover ->
    square = SquareHelper.findSquare $(this)
    square.context.clear square.left, square.top, square.sideLength, square.sideLength
    square.strokeRect "green"

  $noTouchIcons.mouseout ->
    square = SquareHelper.findSquare $(this)
    square.context.clear 0, 0, square.canvas.width, square.canvas.height
    for square in square.canvas.squares
      square.draw()

##### resize adjustments

$(window).resize ->
  ResizeHelper.handleResize()

$(window).bind 'orientationchange', ->
  orientation = window.orientation

  if orientation isnt ResizeHelper.windowOrientation
    ResizeHelper.handleResize()
    ResizeHelper.windowOrientation = orientation