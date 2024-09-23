return function ( cfg )
  -- this effectivly maximizes wezterm
  cfg.initial_rows = 200
  cfg.initial_cols = 200

  cfg.window_decorations = 'TITLE|RESIZE'
  cfg.enable_wayland = true
  cfg.window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 0,
  }
end
