getIconPaths = ($icon) ->
  $object    = $icon.find('object')[0]
  svgDoc     = $object.contentDocument
  svgContext = svgDoc.documentElement

  return $('path, rect, circle, polygon', svgContext).not("[fill='#027D12']")

assignTransitionCss = ($paths) ->
  $paths.css
    WebkitTransition: 'fill .5s linear'
    MozTransition: 'fill .5s linear'
    OTransition: 'fill .5s linear'
    transition: 'fill .5s linear'

unless Modernizr.touch
  $(window).load ->
    $icons = $('.icon').not('.no-hover')
    
    $icons.each ->
      $paths = getIconPaths $(this)
      assignTransitionCss($paths)

      $(this).hover (ev) ->
        $paths.css 'fill', BASE_COLORS.darkGray
      , ->
        $paths.css 'fill', ""