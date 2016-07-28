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
    
onIconMouseEnter = ($paths, $icon) ->
  (ev) ->
    # mouseover
    $paths.css 'fill', BASE_COLORS.darkGray
    $icon.css { backgroundColor: BASE_COLORS.green } if !Modernizr.csstransitions

onIconMouseOut = ($paths, $icon) ->
  (ev) ->
    $paths.css 'fill', ''
    $icon.css { backgroundColor: "" } if !Modernizr.csstransitions
    
applyHoverLogic = ($icon, $hoverElement) ->
  $object = $icon.find('object')
  $svgContext = getSvgContext $icon
  $paths = getPaths $svgContext
  $svg = getSvg $svgContext
  assignTransitionCss($paths)
  
  $hoverElement.hover onIconMouseEnter($paths, $icon), onIconMouseOut($paths, $icon)

unless Modernizr.touch
  $(window).load ->
    $cards = $('.card').not('.no-hover')
    $icons = $('.icon').not('.no-hover').not('.logo')
    
    # $cards.each ->
    #   $card = $(this)
    #   $icon = $card.find('.card-icon')
    #   applyHoverLogic($icon, $card)
    
    $icons.each ->
      $icon = $(this)
      applyHoverLogic($icon, $icon)

    $logos = $('#business-logos .logo')
    
    $logos.hover (ev) ->
      # mouseover
      $(this).css { backgroundColor: BASE_COLORS.green } if !Modernizr.csstransitions
    , ->
      # mouseout
      $(this).css { backgroundColor: "" } if !Modernizr.csstransitions

