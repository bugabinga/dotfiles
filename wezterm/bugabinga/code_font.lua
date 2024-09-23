local wez = require 'wezterm'

return {
  random = function ()
    local font_names = {}
    local nerdfonts = io.open( wez.config_dir .. '/bugabinga/code_fonts', 'r' )
    if nerdfonts then
      for font_name in nerdfonts:lines() do
        if not font_name:match '^#.*' then
          table.insert( font_names, font_name )
        end
      end
      local random_font = font_names[math.random( #font_names )]
      return wez.font( random_font )
    end
    return wez.font 'JetBrains Mono'
  end,
}
