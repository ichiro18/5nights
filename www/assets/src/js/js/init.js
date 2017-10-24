(function() {
  (function($) {
    $(function() {
      $('.button-collapse').sideNav();
      $('.slider').slider();
      $('.parallax').parallax();
      $('.elem').click(function() {
        var SelectedItem, selectedTheme;
        SelectedItem = this.id;
        selectedTheme = SelectedItem + '-theme';
        $('body').removeClass('light-theme');
        $('body').removeClass('dark-theme');
        $('body').removeClass('green-theme');
        $('body').addClass(selectedTheme);
        return console.log(selectedTheme);
      });
    });
  })(jQuery);

}).call(this);
