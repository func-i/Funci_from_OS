getSvgContext = ($icon) ->
  $object = $icon.find('object')[0]
  svgDoc  = $object.contentDocument
  return svgDoc.documentElement

getPaths = ($svgContext) ->
  return $('path, rect, circle, polygon', $svgContext).not("[fill='#027D12']")

getSvg = ($svgContext) ->
  return $('svg', $svgContext)

assignTransitionCss = ($paths) ->
  $paths.css
    WebkitTransition: 'fill .5s linear'
    MozTransition: 'fill .5s linear'
    OTransition: 'fill .5s linear'
    transition: 'fill .5s linear'

unless Modernizr.touch
  $(window).load ->
    $icons = $('.icon').not('.no-hover').not('.logo')
    
    $icons.each ->
      $icon = $(this)
      $object = $icon.find('object')
      $svgContext = getSvgContext $icon
      $paths = getPaths $svgContext
      $svg = getSvg $svgContext
      assignTransitionCss($paths)

      $icon.hover (ev) ->
        # mouseover
        $paths.css 'fill', BASE_COLORS.darkGray
        $icon.css { backgroundColor: BASE_COLORS.green } if !Modernizr.csstransitions
      , ->
        # mouseout
        $paths.css 'fill', ''
        $icon.css { backgroundColor: "" } if !Modernizr.csstransitions

    $logos = $('#business-logos .logo')
    
    $logos.hover (ev) ->
      # mouseover
      $(this).css { backgroundColor: BASE_COLORS.green } if !Modernizr.csstransitions
    , ->
      # mouseout
      $(this).css { backgroundColor: "" } if !Modernizr.csstransitions

