$(function() {
  var DURATION = 750;
  var OFFSET = 27;
  var ANIMATE = false;
  
  function isLocalLink(context) {
    return location.pathname.replace(/^\//,'') == context.pathname.replace(/^\//,'')
      && location.hostname == context.hostname;
  }
  
  //Taken from CSS tricks, smooth scroll down to local link
  $('a[href*="#"]:not([href="#"])').click(function() {
    if (isLocalLink(this)) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html, body').animate({
          scrollTop: target.offset().top - OFFSET
        }, ANIMATE ? DURATION : 0);
        return false;
      }
    }
    
  });
});