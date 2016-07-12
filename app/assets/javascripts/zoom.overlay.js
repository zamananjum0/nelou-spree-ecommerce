(function ($) {
  'use strict';

  $.fn.zoomOverlay = function (selector) {

    var $this = $(this);

    // Detect if this is a touch device
    var isTouch = false;
    $(document).one('touchstart', function(){
      isTouch = true;
    });

    $this.on('click', function () {
      var src = $this.find(selector).data('large');
      var $overlay = $('#flyout');

      function closeOverlay() {
        $overlay.fadeOut('fast');
        $('html, body').scrollTop(0,0);
        // Remove Document Event Listener
        $(document).off('mousemove keydown');
        $(window).off('blur mouseleave');
        $('body').removeClass('flyout-open');
      }

      $(document).on('keydown', function(e) {
      // ESCAPE key pressed
        if (e.keyCode == 27) {
          closeOverlay();
        }
      });

      if(!$overlay.length) {
        $overlay = $('<div id="flyout" class="flyout-container"></div>').appendTo($('body')).on('click', function () {
          closeOverlay();
        });
      }

      $overlay.empty().addClass('loading');

      var $img = $('<img />', { src: src, class: 'zoomImg' }).on('load', function () {
        $overlay.removeClass('loading');

        $(document).on('mousemove', function(e) {
          if ( isTouch == false ) {
            $('body').addClass('flyout-open');
            $('html, body').scrollTop(function() {
              var _winheight = $(window).height(),
                _imgheight = $img.height(),
                _diff = _imgheight - _winheight,
                _t_percent = e.clientY / _winheight,
                _t = _t_percent * _diff;

              return _t;
            });
          }
        });

      });

      $overlay.append($img).fadeIn('slow');
    })
  }

} (window.jQuery));
