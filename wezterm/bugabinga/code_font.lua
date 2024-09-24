local wez = require 'wezterm'

return {
  random = function ()
    local selected = 'JetBrains Mono' -- safe default, because built in to wezterm
    local font_names = {}
    local weights = {}
    local total_weight = 1 -- to account for luas 1 based indexing
    local code_fonts = io.open( wez.config_dir .. '/bugabinga/code_fonts.csv', 'r' )

    if code_fonts then
      for line in code_fonts:lines() do
        local weight, font_name = line:match '^%s*(%d*)%s*,%s*(.*)%s*$'
        table.insert( font_names, font_name )
        table.insert( weights,    tonumber( weight ) )
        total_weight = total_weight + weight
      end
      code_fonts:close()

      local random_weight = math.random( total_weight )
      local cursor = 0
      for idx, weight in ipairs( weights ) do
        cursor = cursor + weight
        if cursor >= random_weight then
          selected = font_names[idx]
          break
        end
      end
    end

    return wez.font( selected )
  end,
}
