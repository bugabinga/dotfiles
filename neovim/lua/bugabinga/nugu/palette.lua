local palette_dark = require 'bugabinga.nugu.palette_dark'
local palette_light = require 'bugabinga.nugu.palette_light'

local choose = function ( variants )
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt.background:get() == 'dark' then
    return variants.dark
  else
    return variants.light
  end
end

return {
  debug = choose { light = palette_light.debug, dark = palette_dark.debug },
  error = choose { light = palette_light.error, dark = palette_dark.error },
  info = choose { light = palette_light.info, dark = palette_dark.info },
  warning = choose { light = palette_light.warning, dark = palette_dark.warning },

  content_normal = choose { light = palette_light.content_normal, dark = palette_dark.content_normal },
  content_backdrop = choose { light = palette_light.content_backdrop, dark = palette_dark.content_backdrop },
  content_accent = choose { light = palette_light.content_accent, dark = palette_dark.content_accent },
  content_minor = choose { light = palette_light.content_minor, dark = palette_dark.content_minor },
  content_focus = choose { light = palette_light.content_focus, dark = palette_dark.content_focus },
  content_unfocus = choose { light = palette_light.content_unfocus, dark = palette_dark.content_unfocus },
  content_important_global = choose { light = palette_light.content_important_global, dark = palette_dark.content_important_global },
  content_important_local = choose { light = palette_light.content_important_local, dark = palette_dark.content_important_local },

  ui_normal = choose { light = palette_light.ui_normal, dark = palette_dark.ui_normal },
  ui_backdrop = choose { light = palette_light.ui_backdrop, dark = palette_dark.ui_backdrop },
  ui_accent = choose { light = palette_light.ui_accent, dark = palette_dark.ui_accent },
  ui_minor = choose { light = palette_light.ui_minor, dark = palette_dark.ui_minor },
  ui_focus = choose { light = palette_light.ui_focus, dark = palette_dark.ui_focus },
  ui_unfocus = choose { light = palette_light.ui_unfocus, dark = palette_dark.ui_unfocus },
  ui_important_global = choose { light = palette_light.ui_important_global, dark = palette_dark.ui_important_global },
  ui_important_local = choose { light = palette_light.ui_important_local, dark = palette_dark.ui_important_local },
}
