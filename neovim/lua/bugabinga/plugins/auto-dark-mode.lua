return {
  'f-person/auto-dark-mode.nvim',
  dev = true,
  lazy = false,
  opts = {
    -- interval of 0 freezes neovim on quit
    -- update_interval = 0,
    update_interval = 5000,
    set_dark_mode = function ()
      vim.opt.background = 'dark'
    end,
    set_light_mode = function ()
      vim.opt.background = 'light'
    end,
  },
}
