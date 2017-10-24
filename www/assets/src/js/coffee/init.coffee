(($) ->
  $ ->
    $('.button-collapse').sideNav()
    $('.slider').slider();
    $('.parallax').parallax();

    $('.elem').click ->
      SelectedItem = this.id
      selectedTheme = SelectedItem + '-theme'
      $('body').removeClass('light-theme')
      $('body').removeClass('dark-theme')
      $('body').removeClass('green-theme')
      $('body').addClass(selectedTheme)
      console.log(selectedTheme)
    return
  # end of document ready
  return
) jQuery