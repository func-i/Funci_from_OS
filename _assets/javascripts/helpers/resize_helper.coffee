@ResizeHelper =
  currentSceneIndex: 0

  resizeSquares: ($squares) ->
    $squares.css 'width', '100%'
    widths = $squares.map ->
      $square = $(this)
      Math.round($square.outerWidth())    
    $squares.each (i) ->
      $square = $(this)
      $square.css 'width', widths[i]
      $square.css 'height', widths[i]
  
  isDesktopSized: () ->
    window.innerWidth > window.SCREEN_WIDTH_UPPER_LIMITS.medium &&
    window.innerHeight > window.SCREEN_HEIGHT_LOWER_LIMIT
  
  resizeIndex: () ->
    if ResizeHelper.isDesktopSized()
      $('#index').css('height', window.innerHeight)
    else
      $('#index').css('height', '')

  resizeScenes: ($scenes) ->
    $scenes.each((index, scene) ->
      $scene = $(scene)
      $scene.css('height', "")
      if $scene.attr('id') != "footer-scene" || ResizeHelper.isDesktopSized()
        # Set size of each scene to window height
        $scene.css('height', Math.max(window.innerHeight, $scene.innerHeight()))
    )
    
  toggleSceneTransform: () ->
    if @isDesktopSized()
      window.scrollTo(0, 0)
      $('body').css('overflow', 'hidden')
      @applySceneTransform(@currentSceneIndex)
    else
      $('body').css('overflow', '')
      @removeSceneTransform()
  
  removeSceneTransform: () ->
    $('#cube-scenes').css('transform', "")
    
  applySceneTransform: (sceneIndex) ->
    if @isDesktopSized()
      @currentSceneIndex = sceneIndex
      $('#cube-scenes').css('transform', "translate3d(0, #{-sceneIndex * window.innerHeight}px, 0)")

  resizeNav: ($menuLink) ->
    $navMenu = $('.nav-menu')
    if $menuLink.length > 0 && window.innerWidth > window.SCREEN_WIDTH_UPPER_LIMITS.medium
      $subMenuLinks = $menuLink.siblings().children()
      newNavWidth = parseInt($subMenuLinks.css('width'), 10) * $subMenuLinks.length + 75 # The extra 75 is from the size of the selected nav-menu-item when the sub-menu is open
      $navMenu.css('width', Math.min(newNavWidth, window.innerWidth))
    else if window.innerWidth <= window.SCREEN_WIDTH_UPPER_LIMITS.medium
      $navMenu.css('width', '')

  handleResize: (args) ->
    
    @resizeSquares($('.square'))
    @resizeSquares($('.square-no-canvas'))
    @resizeSquares($('.square-no-canvas-no-fill'))
    @resizeNav($('.nav-menu-item.active > .nav-menu-item-link'))
    
    if ($('#index').length > 0)
      @resizeIndex()
      @resizeScenes($('.cube-scene'))
      @toggleSceneTransform()
    
    for canvas in window.canvases
      canvas.orient()
      canvas.context.clear 0, 0, canvas.width, canvas.height
      canvas.context.setMultiply()

      for square in canvas.squares
        square.orient()

      canvas.adjustSquarePositions()
      
      for square in canvas.squares
        square.draw()

  windowOrientation: undefined