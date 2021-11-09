local wez = require'wezterm'
return {
  font = wez.font'JetBrainsMono Nerd Font',
  font_size = 13.0,
  color_scheme = 'nord',
  default_prog  = {'nu'},
  window_decorations = 'RESIZE',
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  tab_max_width = 24,
  window_padding = {
    left = 8,
    right = 8,
    top = 4,
    bottom = 4,
  },
  colors = {
    tab_bar = {
      background = '#0B0022',
      active_tab = {
        bg_color = '#2B2042',
        fg_color = '#C0C0C0',
        intensity = 'Bold',
      },
      inactive_tab_hover = {
        bg_color = '#3B3052',
        fg_color = '#C0C0C0',
        italic = false,
        intensity = 'Half',
      },
    }
  }
}
