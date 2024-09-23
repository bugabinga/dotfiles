local nerd_font = require 'bugabinga.nerd_font'

return function ( cfg )
  cfg.font = nerd_font.random();

  cfg.background = {
    {
      source = {
        File = '/home/oli/Pictures/Bilder/2012/05/20/Waldshooting_vonni_tini_2012 (12).jpg',
      },
      hsb = {
        hue = 1.0,
        saturation = 0.0,
        brightness = 0.004,
      },
      attachment = { Parallax = 0.006, },
      vertical_align = 'Middle',
      horizontal_align = 'Center',
    },
    {
      source = {
        Gradient = {
          colors = { 'purple', '#131313', },
          orientation = {
            Radial = {
              cx = 0.5,
              cy = 0.5,
              radius = 1.25,
            },
          },
        },
      },
      opacity = 0.1,
      width = '100%',
      height = '100%',
    },
  }
end
