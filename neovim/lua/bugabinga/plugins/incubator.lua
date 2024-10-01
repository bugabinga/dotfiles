-- this file lists plugins in their "incubation" phase.
-- that means i am testing those out of curiosity, but am not sure yet i wish
-- to use and depend on them.

-- global toggle for all incubating plugins. set to false to quickly, but
-- temporarily, get rid of all incubating plugins.
local FUCK_STABILITY = true

local ignored = require 'std.ignored'
local icon = require 'std.icon'

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
    -- FIXME: if view stays open, when saving session, reloading the session results in borked view.
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
      position = 'right',
      width = 69,
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
    'chrisgrieser/nvim-dr-lsp',
    event = 'LspAttach',
    opts = {},
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    opts = {},
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    -- FIXME: no worky in wezterm ?
    -- mouse idle seems to send no event.
    'soulis-1256/eagle.nvim',
    lazy = false,
    init = function ()
      vim.o.mousemoveevent = true
    end,
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    'quentingruber/timespent.nvim',
    keys = {
      {
        '<leader>tS',
        '<cmd>:ShowTimeSpent<cr>',
        mode = { 'n' },
        desc = 'Show time spent',
      },
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

  {
    'cenk1cenk2/scratch.nvim',
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    'AdeAttwood/ivy.nvim',
    lazy = false,
    build = 'cargo build --release',
    opts = {},
    enabled = false,
    -- this one is not ready yet, but looks promising
  },
  -------------------------------------------------------------------------------
  {
    'roobert/surround-ui.nvim',
    lazy = false,
    dependencies = {
      'kylechui/nvim-surround',
      'folke/which-key.nvim',
    },
    opts = {
      root_key = 'ms',
    },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'LspAttach',
    config = function ()
      require 'tiny-inline-diagnostic'.setup()
    end,
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
    'chrisgrieser/nvim-lsp-endhints',
    event = 'LspAttach',
    opts = {
      icons = {
        type = icon.type .. ' ',
        parameter = icon.paramter,
        offspec = '',        -- hint kind not defined in official LSP spec
        unknown = icon.hint, -- hint kind
      },
      label = {
        padding = 2,
      },
    },
    enabled = FUCK_STABILITY,
  },
  -------------------------------------------------------------------------------
  {
    -- FIXME: does not seem to worky? at least for lua.
    'zbirenbaum/neodim',
    event = 'LspAttach',
    opts = {},
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
    'ravibrock/spellwarn.nvim',
    event = 'VeryLazy',
    config = true,
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
    'tris203/precognition.nvim',
    event = 'VeryLazy',
    opts = {
      startVisible = true,
      showBlankVirtLine = true,
      highlightColor = { link = 'LineNr' },
      -- hints = {
      --      Caret = { text = "^", prio = 2 },
      --      Dollar = { text = "$", prio = 1 },
      --      MatchingPair = { text = "%", prio = 5 },
      --      Zero = { text = "0", prio = 1 },
      --      w = { text = "w", prio = 10 },
      --      b = { text = "b", prio = 9 },
      --      e = { text = "e", prio = 8 },
      --      W = { text = "W", prio = 7 },
      --      B = { text = "B", prio = 6 },
      --      E = { text = "E", prio = 5 },
      -- },
      -- gutterHints = {
      --     G = { text = "G", prio = 10 },
      --     gg = { text = "gg", prio = 9 },
      --     PrevParagraph = { text = "{", prio = 8 },
      --     NextParagraph = { text = "}", prio = 8 },
      -- },
      disabled_fts = ignored.filetypes,
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
  {
    'shortcuts/no-neck-pain.nvim',
    lazy = false,
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
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'debugloop/layers.nvim',
        opts = {},
      },
    },
    keys = {
      {
        '<leader>d',
        function ()
          local dap = require 'dap'
          if dap.session() ~= nil then
            DEBUG_MODE:activate()
            return
          end
          dap.continue()
        end,
        desc = 'launch debugger',
      },
      opts = {},
      config = function ( _, opts )
        local dap = require 'dap'
        -- do the setup you'd do anyway for your language of choice
        dap.adapters = opts.adapters
        dap.configurations = opts.configurations
        -- this is where the example starts
        DEBUG_MODE = Layers.mode.new() -- global, accessible from anywhere
        DEBUG_MODE:auto_show_help()
        -- this actually relates to the next example, but it is most convenient to add here
        DEBUG_MODE:add_hook( function ( _ )
          vim.cmd 'redrawstatus' -- update status line when toggled
        end )
        -- nvim-dap hooks
        dap.listeners.after.event_initialized['debug_mode'] = function ()
          DEBUG_MODE:activate()
        end
        dap.listeners.before.event_terminated['debug_mode'] = function ()
          DEBUG_MODE:deactivate()
        end
        dap.listeners.before.event_exited['debug_mode'] = function ()
          DEBUG_MODE:deactivate()
        end
        -- map our custom mode keymaps
        DEBUG_MODE:keymaps {
          n = {
            {
              's',
              function ()
                dap.step_over()
              end,
              { desc = 'step forward' },
            },
            {
              'c',
              function ()
                dap.continue()
              end,
              { desc = 'continue' },
            },
            { -- this acts as a way to leave debug mode without quitting the debugger
              '<esc>',
              function ()
                DEBUG_MODE:deactivate()
              end,
              { desc = 'exit' },
            },
          },
        }
      end,
    },
    enabled = FUCK_STABILITY,
  },
}
