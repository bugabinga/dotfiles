return {
  {
    'JosefLitos/colorizer.nvim',
    event = 'VeryLazy',
    opts = {
      filetypes = { '*', },
      user_default_options = {
        RGB = true,           -- #RGB hex codes
        RRGGBB = true,        -- #RRGGBB hex codes
        RRGGBBAA = true,      -- #RRGGBBAA hex codes
        AARRGGBB = true,      -- 0xAARRGGBB hex codes
        rgb_fn = true,        -- CSS rgb() and rgba() functions
        hsl_fn = true,        -- CSS hsl() and hsla() functions
        css = false,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = 'virtualtext', -- Set the display mode.
        -- names = function () return require 'bugabinga.nugu.palette' end,
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { 'css', }, }, -- Enable sass colors
        virtualtext = '██',
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = false,
      },
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {
        '*',
        '!prompt',
        '!popup',
        '!nofile',
      },
    },
  },
}
