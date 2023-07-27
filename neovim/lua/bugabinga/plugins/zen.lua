return {
  "folke/zen-mode.nvim",
  cmd = 'ZenMode',
  dependencies = { { 'folke/twilight.nvim', opts = { dimming = { inactive = true } } } },
  opts = {
    plugins = { wezterm = { enabled = true, font = "+4" } },
    window = {
      width = 0.69,
      backdrop = 0.42,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = "0",
        list = false,
      },
    },
  },
}
