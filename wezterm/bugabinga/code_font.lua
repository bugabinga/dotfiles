local wez = require 'wezterm'
local csv_line_pattern = '^%s*(%d+)%s*,%s*(.-)%s*$'

local adjust_font_randomness_weight = function ( font_family, adjust )
  local code_fonts = io.open( wez.config_dir .. '/bugabinga/code_fonts.csv', 'r+' )
  if code_fonts then
    local new_lines = {}
    for line in code_fonts:lines() do
      local weight, font_name = line:match(csv_line_pattern)
      if not weight or not font_name then
        wez.log_error 'Could not parse code_fonts.csv. Borked?'
        return
      end
      weight = tonumber( weight )
      if font_name == font_family then
        weight = math.max( 0, adjust( weight ) )
      end
      table.insert( new_lines, weight .. ',' .. font_name )
    end
    code_fonts:seek( 'set', 0 )
    for _, new_line in ipairs( new_lines ) do
      code_fonts:write( new_line, '\n' )
    end
    code_fonts:close()
  else
    wez.log_error 'Unable to read and write code_fonts.csv!'
  end
end

-- like the current font.
-- liked fonts have higher probablity of being picked on wezterm boot.
-- increase the weight of the font in code_fonts.csv.
-- not to be confused with a font weigth (aka bold).
-- here weight means the likelyhood of being "randomly" picked.
local like_current_font = function ( window )
  local font = window:effective_config().font.font
  -- not sure why font is a list
  local family = font[1].family
  adjust_font_randomness_weight( family, function ( weight )
    local new_weight = weight + 1
    -- TODO: remove notification once weight is displayed in status
    window:toast_notification( 'code_fonts', 'Font ' .. family .. '(' .. new_weight .. ') liked! ', nil, 500 )
    return new_weight
  end )
end

local dislike_current_font = function ( window )
  local font = window:effective_config().font.font
  -- not sure why font is a list
  local family = font[1].family
  adjust_font_randomness_weight( family, function ( weight )
    local new_weight = weight - 1
    window:toast_notification( 'code_fonts', 'Font ' .. family .. '(' .. new_weight .. ') NOT liked! ', nil, 500 )
    return new_weight
  end )
end

local ban_current_font = function ( window )
  local font = window:effective_config().font.font
  -- not sure why font is a list
  local family = font[1].family
  adjust_font_randomness_weight( family, function ()
    window:toast_notification( 'code_fonts', 'Font ' .. family .. ' BANNED!', nil, 500 )
    return 0
  end )
end

-- register those events with wezterm, so that key binds can trigger them
wez.on( 'like-current-font',    like_current_font )
wez.on( 'dislike-current-font', dislike_current_font )
wez.on( 'ban-current-font',     ban_current_font )

local random = function ()
  local selected = 'JetBrains Mono' -- safe default, because built in to wezterm
  local font_names = {}
  local weights = {}
  local total_weight = 1 -- to account for luas 1 based indexing
  local code_fonts = io.open( wez.config_dir .. '/bugabinga/code_fonts.csv', 'r' )

  if code_fonts then
    for line in code_fonts:lines() do
      print('csv line: ' , line)
      local weight, font_name = line:match(csv_line_pattern)
      if not weight or not font_name then
        wez.log_error 'Could not parse code_fonts.csv. Borked?'
        break
      end
      weight = tonumber( weight )
      table.insert( font_names, font_name )
      table.insert( weights,    weight )
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
end

return {
  like_current_font = like_current_font,
  dislike_current_font = dislike_current_font,
  ban_current_font = ban_current_font,
  random = random,
}
