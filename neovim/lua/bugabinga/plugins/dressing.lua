--FIXME: own this. is vim.ui.open shim still necessary?
return {
  "stevearc/dressing.nvim",
  lazy = false,
  opts = {
    input = {
      insert_only = false,
      -- relative = "editor",
      win_options = {
        sidescrolloff = 4,
      },
      get_config = function()
        if vim.api.nvim_win_get_width(0) < 50 then
          return {
            relative = "editor",
          }
        end
      end,
    },
    select = {
      backend = { "telescope", "builtin", "fzf_lua" },
    },
  },
  config = function(_, opts)
    require("dressing").setup(opts)

    -- Shim for vim.ui.open
    if vim.ui.open then
      return
    end

    ---Copied from vim.ui.open in Neovim 0.10+
    ---@param path string
    ---@return nil|string[] cmd
    ---@return nil|string error
    local function get_open_cmd(path)
      if vim.fn.has("mac") == 1 then
        return { "open", path }
      elseif vim.fn.has("win32") == 1 then
        if vim.fn.executable("rundll32") == 1 then
          return { "rundll32", "url.dll,FileProtocolHandler", path }
        else
          return nil, "rundll32 not found"
        end
      elseif vim.fn.executable("wslview") == 1 then
        return { "wslview", path }
      elseif vim.fn.executable("xdg-open") == 1 then
        return { "xdg-open", path }
      else
        return nil, "no handler found"
      end
    end

    vim.ui.open = function(path)
      local is_uri = path:match("%w+:")
      if not is_uri then
        path = vim.fn.expand(path)
      end
      local cmd, err = get_open_cmd(path)
      if not cmd or err then
        return nil, err
      end
      local jid = vim.fn.jobstart(cmd, { detach = true })
      if jid <= 0 then
        return nil, "Failed to start job"
      end
    end
  end,
}
