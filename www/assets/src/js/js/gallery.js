(function() {
  var filterData, filterTpl, galleryData, galleryTpl;

  filterTpl = {
    '<>': 'button',
    'class': 'button light-blue${checked} waves-effect waves-light btn hvr-shrink',
    'data-filter': '${filter}',
    'html': '${name}'
  };

  filterData = [
    {
      'checked': ' is-checked',
      'filter': '*',
      'name': 'show all'
    }, {
      'checked': '',
      'filter': '.development',
      'name': 'Development'
    }, {
      'checked': '',
      'filter': '.design',
      'name': 'Design'
    }, {
      'checked': '',
      'filter': '.jquery',
      'name': 'Jquery'
    }, {
      'checked': '',
      'filter': '.isotope',
      'name': 'Isotope'
    }
  ];

  galleryTpl = {
    '<>': 'div',
    'class': 'element-item ${category}',
    'html': [
      {
        '<>': 'img',
        'class': 'materialboxed hvr-shrink',
        'width': '250',
        'height': '150',
        'src': '${img}',
        'data-caption': '${caption}',
        'html': ''
      }
    ]
  };

  galleryData = [
    {
      'category': 'development',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here1'
    }, {
      'category': 'design',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'jquery',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'isotope',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'development',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'design',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'jquery',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'isotope',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'development',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'design',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'jquery',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'isotope',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'development',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'design',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'jquery',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }, {
      'category': 'isotope',
      'img': 'http://www.placehold.it/600x400',
      'caption': 'Add caption here'
    }
  ];

  $('#filters').jsonRender(filterData, filterTpl);

  $('#grid').jsonRender(galleryData, galleryTpl);

  $(document).ready(function() {
    var $grid;
    $('.materialboxed').materialbox();
    $grid = $('.grid').isotope({
      itemSelector: '.element-item',
      layoutMode: 'fitRows'
    });
    $('#filters').on('click', 'button', function() {
      var filterValue;
      filterValue = $(this).attr('data-filter');
      $grid.isotope({
        filter: filterValue
      });
    });
    $('.button-group').each(function(i, buttonGroup) {
      var $buttonGroup;
      $buttonGroup = $(buttonGroup);
      $buttonGroup.on('click', 'button', function() {
        $buttonGroup.find('.is-checked').removeClass('is-checked');
        $(this).addClass('is-checked');
      });
    });
    $(window).scroll(function() {
      if ($(this).scrollTop() > 50) {
        $('.scrolltop:hidden').stop(true, true).fadeIn();
      } else {
        $('.scrolltop').stop(true, true).fadeOut();
      }
    });
    $(function() {
      $('.scroll').click(function() {
        $('html,body').animate({
          scrollTop: $('#gallery').offset().top
        }, '1000');
        return false;
      });
    });
  });

}).call(this);
