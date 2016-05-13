(function($) {
  "use strict";

  $.fn.blogify = function() {
    return this.each(function() {
      var $$ = $(this),
        target = $$.data('target'),
        $target,
        feedUrl = $$.data('feed');

      if (target) {
        $target = $(target);
      } else {
        $target = $$;
      }

      if (!feedUrl) {
        $target.hide();
        return $(this);
      }

      $.ajax({
        url: feedUrl,
        type: 'GET',
        dataType: 'jsonp',
        success: function(data) {
          var $list = $('<ul class="blog-excerpt-list"></ul>'),
            item,
            length = Math.min(data.length, 3);
          for (var i = 0; i < length; i++) {
            item = data[i];
            $('<li class="blog-excerpt-item"><a href="' + item.permalink + '" target="_blank" class="blog-excerpt-item-link"><span class="blog-excerpt-item-title">' + item.title + '</span><span class="blog-excerpt">' + item.excerpt + '</span></a></li>').appendTo($list);
          }
          $target.show().empty().append($list);
        },
        error: function() {
          $target.hide();
        }
      });

      return $(this);

    });
  };

  $(function() {
    $('#blog').blogify();
  });

}(window.jQuery));
