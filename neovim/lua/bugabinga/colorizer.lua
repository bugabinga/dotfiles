local want = require 'bugabinga.std.want'
want { 'colorizer' }(function(colorizer)
  colorizer.setup({ '*' }, {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = false, -- "Name" codes like Blue oe blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    mode = 'virtualtext', -- Set the display mode.
    virtualtext = '■', -- the virtual text block mode = 'background',
  })
end)
