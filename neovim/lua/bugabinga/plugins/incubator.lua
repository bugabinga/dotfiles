local ignored = require 'std.ignored'
local icon = require 'std.icon'

-- this file lists plugins in their "incubation" phase.
-- that means i am testing those out of curiosity, but am not sure yet i wish
-- to use and depend on them.
--
return {
  -------------------------------------------------------------------------------
  {
    'gregorias/toggle.nvim',
    lazy = false,
    version = '2.0',
    config = true,
  },
  -------------------------------------------------------------------------------
  {
    'quentingruber/timespent.nvim',
    keys = {
      {
        '<leader>tS',
        '<cmd>:ShowTimeSpent<cr>',
        mode = {
          'n',
        },
        desc = 'Show time spent',
      },
    },
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
  },

  {
    'cenk1cenk2/scratch.nvim',
  },
  -------------------------------------------------------------------------------
  {
    'AdeAttwood/ivy.nvim',
    lazy = false,
    build = 'cargo build --release',
    opts = {},
  },
  -------------------------------------------------------------------------------
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'LspAttach',
    config = function ()
      require 'tiny-inline-diagnostic'.setup()
    end,
  },
  -------------------------------------------------------------------------------
  {
    'chrisgrieser/nvim-lsp-endhints',
    event = 'LspAttach',
    opts = {
      icons = {
        type = icon.tye,
        parameter = icon.paramter,
        offspec = '',        -- hint kind not defined in official LSP spec
        unknown = icon.hint, -- hint kind
      },
      label = {
        padding = 2,
      },
    },
  },
  -------------------------------------------------------------------------------
  {
    'ravibrock/spellwarn.nvim',
    event = 'VeryLazy',
    config = true,
  },
  -------------------------------------------------------------------------------
  {
    'emmanueltouzery/decisive.nvim',
    config = function ()
      require 'decisive'.setup {}
    end,
    lazy = true,
    ft = { 'csv' },
    keys = {
      { '<leader>cca', ":lua require('decisive').align_csv({})<cr>",        { silent = true }, desc = 'Align CSV',          mode = 'n' },
      { '<leader>ccA', ":lua require('decisive').align_csv_clear({})<cr>",  { silent = true }, desc = 'Align CSV clear',    mode = 'n' },
      { '[c',          ":lua require('decisive').align_csv_prev_col()<cr>", { silent = true }, desc = 'Align CSV prev col', mode = 'n' },
      { ']c',          ":lua require('decisive').align_csv_next_col()<cr>", { silent = true }, desc = 'Align CSV next col', mode = 'n' },
    },
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
  },
  -------------------------------------------------------------------------------
}
