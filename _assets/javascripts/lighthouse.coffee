class Lighthouse
  constructor: ->
    @$lighthouse   = $('#lighthouse')
    @$wrapper      = @$lighthouse.find('#wrapper')
    @$scene        = @$wrapper.find('.scene')
    @$targetSquare = $('#lighthouse-square')
    @$image        = $('.lighthouse.image')
    @$body         = $('body')
    @positionWithCss()
    @setupEvents()

  setTargetSquarePosition: ->
    offset = @$targetSquare.offset()
    halfSideLength = @$targetSquare.width() / 2

    @targetSquarePosition =
      left: offset.left + halfSideLength
      top: offset.top + halfSideLength

    console.log @targetSquarePosition

  setPercentageOffset: ->
    @setTargetSquarePosition()
    @percentageOffset =
      left: Math.round((@targetSquarePosition.left / @$body.width()) * 100)
      top: Math.round((@targetSquarePosition.top / @$body.height()) * 100)

  positionWithCss: ->
    @setPercentageOffset()
    leftString = "#{@percentageOffset.left}%"
    topString = "#{@percentageOffset.top}%"
    @$wrapper.css
      perspectiveOrigin: "#{leftString} #{topString}"
    @$scene.css
      top: topString
      left: leftString
    @$image.css
      left: "calc(#{leftString} - 100px)"
      top: "calc(#{topString} - 42px)"

  setupEvents: ->


@lighthouse = new Lighthouse()