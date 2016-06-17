window.canvases = []
window.logo = {}
@blendingSupported = Modernizr.canvasblending

onHome = ->
  window.location.pathname is "/"

$loading = $('#loading')
$body    = $('#body')

fadeIn = ->
  $loading.css('opacity', '0')
  $body.css('opacity', '1')
  $loading.remove()

$(window).load ->
  ResizeHelper.handleResize()

fadeIn()

##### make square divs square
$('.square').each ->
  $square = $(this)
  $square.css 'width', ''
  roundedWidth = Math.round $square.outerWidth()
  $square.css 'width', roundedWidth
  $square.css 'height', roundedWidth
  
$('.square-no-canvas').each ->
  $square = $(this)
  roundedWidth = Math.round $square.outerWidth()
  $square.css 'height', roundedWidth

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