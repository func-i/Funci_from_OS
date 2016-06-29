@LoadingHelper =
  fadeIn: () ->
    console.log('fading in')
    $loading = $('#loading')
    $body    = $('#body')
    $footer  = $('footer')
    $loading.css('opacity', '0')
    $body.css('opacity', '1')
    $footer.css('opacity', '1')
    $loading.remove()