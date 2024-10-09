-- this file lists plugins in their "incubation" phase.
-- that means i am testing those out of curiosity, but am not sure yet i wish
-- to use and depend on them.

-- global toggle for all incubating plugins. set to false to quickly, but
-- temporarily, get rid of all incubating plugins.
local FUCK_STABILITY = true

local icon = require 'std.icon'
local dbg = require 'std.dbg'
local ignored = require 'std.ignored'

return {
  -------------------------------------------------------------------------------
  {
    'gregorias/toggle.nvim',
    lazy = false,
    version = '2.0',
    config = true,
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    'zbirenbaum/copilot-cmp',
    event = 'InsertEnter',
    config = function () require 'copilot_cmp'.setup() end,
    dependencies = {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      config = function ()
        require 'copilot'.setup {
          suggestion = { enabled = false },
          panel = { enabled = false },
        }
      end,
    },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    'amrbashir/nvim-docs-view',
    keys = {
      {
        '<leader>tk',
        '<cmd>DocsViewToggle<cr>',
        mode = { 'n' },
        desc = 'Toggle stable documentation panel.',
      },
    },
    cmd = 'DocsViewToggle',
    opts = {
      position = 'bottom',
      width = 42,
    },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    -- TODO: look into demicolon.nvim for ,; repition
    'mawkler/refjump.nvim',
    dependencies = {

    },
    keys = { ']r', '[r' },
    opts = {},
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    cmd = 'CopilotChat',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' },  -- for curl, log wrapper
    },
    build = 'make tiktoken',        -- Only on MacOS or Linux
    opts = {
      debug = true,                 -- Enable debugging
    },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    -- TODO: this is pretty great! i just need better binds and tell which key about them
    'chrisgrieser/nvim-rulebook',
    keys = {
      { '<leader>ri', function () require 'rulebook'.ignoreRule() end },
      { '<leader>rl', function () require 'rulebook'.lookupRule() end },
      { '<leader>ry', function () require 'rulebook'.yankDiagnosticCode() end },
      { '<leader>sf', function () require 'rulebook'.suppressFormatter() end, mode = { 'n', 'x' } },
    },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    -- this plugin has some sick visual text formatting chops. check them out some time.
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    opts = {
      hi = { link = 'LineNr' },
      vt_position = 'end_of_line',
      request_pending_text = false,
      disable = {
        filetypes = ignored.filetypes,
      },
      log = { enabled = dbg.get() },
    },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    'nvim-telescope/telescope-frecency.nvim',
    config = function ()
      require 'telescope'.load_extension 'frecency'
    end,
    keys = {
      {
        '<c-p><c-f>',
        '<cmd>Telescope frecency<cr>',
        mode = { 'n' },
        desc = 'telescope: Show recently and  frequently used files.',
      },
    },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    'winston0410/range-highlight.nvim',
    lazy = false,
    dependencies = { 'winston0410/cmd-parser.nvim' },
    opts = { highlight = 'Visual' },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
   'rafcamlet/nvim-luapad',
    cmd = { 'Luapad', 'LuaRun' },
    opts = {},
    enabled = FUCK_STABILITY,

  },
  -------------------------------------------------------------------------------
  {
    'emmanueltouzery/decisive.nvim',
    config = function ()
      require 'decisive'.setup {}
    end,
    ft = { 'csv' },
    keys = {
      { '<leader>cca', ":lua require('decisive').align_csv({})<cr>",        { silent = true }, desc = 'Align CSV',          mode = 'n' },
      { '<leader>ccA', ":lua require('decisive').align_csv_clear({})<cr>",  { silent = true }, desc = 'Align CSV clear',    mode = 'n' },
      { '[c',          ":lua require('decisive').align_csv_prev_col()<cr>", { silent = true }, desc = 'Align CSV prev col', mode = 'n' },
      { ']c',          ":lua require('decisive').align_csv_next_col()<cr>", { silent = true }, desc = 'Align CSV next col', mode = 'n' },
    },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    'folke/lazydev.nvim',
    dependencies = { 'justinsgithub/wezterm-types' },
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- Or relative, which means they will be resolved from the plugin dir.
        'lazy.nvim',
        -- It can also be a table with trigger words / mods
        -- Only load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        -- Load the wezterm types when the `wezterm` module is required
        -- Needs `justinsgithub/wezterm-types` to be installed
        { path = 'wezterm-types',      mods = { 'wezterm' } },
      },
    },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    -- TODO: bind IMove* to alt+h and alt+l with fallback to gomove
    -- NOTE: if this one does not work out, check https://github.com/Wansmer/sibling-swap.nvim
    'mizlan/iswap.nvim',
    event = 'VeryLazy',
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
}
