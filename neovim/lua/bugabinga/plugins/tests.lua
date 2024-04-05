local debug = require 'std.dbg'
local icon = require 'std.icon'
local map = require 'std.map'

map.normal {
  description = 'Run all tests',
  category = 'test',
  keys = '<leader>7n',
  command = function () prequire 'neotest'.run.run {} end,
}

map.normal {
  description = 'Run all tests',
  category = 'test',
  keys = '<leader>7n',
  command = function () prequire 'neotest'.run.run {} end,
}

map.normal {
  description = 'Run tests for current file',
  category = 'test',
  keys = '<leader>7t',
  command = function () prequire 'neotest'.run.run { vim.api.nvim_buf_get_name( 0 ), } end,
}

map.normal {
  description = 'Run all test suites',
  category = 'test',
  keys = '<leader>7a',
  command = function ()
    for _, adapter_id in ipairs( require 'neotest'.run.adapters() ) do
      prequire 'neotest'.run.run { suite = true, adapter = adapter_id, }
    end
  end,
}

map.normal {
  description = 'Run last test',
  category = 'test',
  keys = '<leader>7l',
  command = function () prequire 'neotest'.run.run_last() end,
}

map.normal {
  description = 'Run all tests in debugger',
  category = 'test',
  keys = '<leader>7d',
  command = function () prequire 'neotest'.run.run { strategy = 'dap', } end,
}

map.normal {
  description = 'Show test summary',
  category = 'test',
  keys = '<leader>7p',
  command = function () prequire 'neotest'.summary.toggle() end,
}

map.normal {
  description = 'Show test output',
  category = 'test',
  keys = '<leader>7o',
  command = function () prequire 'neotest'.output.open { short = true, } end,
}

-- Investigate:
-- * Does neotest have ability to throttle groups of individual test runs?
-- * Tangential, but also check out https://github.com/andythigpen/nvim-coverage
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-neotest/neotest-plenary',
    'nvim-neotest/nvim-nio',
    'stevearc/overseer.nvim',
  },

  config = function ()
    local neotest = require 'neotest'
    if debug.get() then
      require 'neotest.logging':set_level 'trace'
    end
    neotest.setup {
      adapters = {
        require 'neotest-plenary',
      },
      discovery = {
        enabled = false,
      },
      consumers = {
        overseer = prequire 'neotest.consumers.overseer',
      },
      summary = {
        mappings = {
          attach = 'a',
          expand = 'l',
          expand_all = 'L',
          jumpto = 'gf',
          output = 'o',
          run = '<C-r>',
          short = 'p',
          stop = 'u',
        },
      },
      icons = {
        passed = icon.passed,
        running = icon.running,
        failed = icon.failed,
        unknown = icon.unknown,
        running_animated = vim.tbl_map(
          function ( s ) return s .. ' ' end,
          {
            icon.progress_0,
            icon.progress_1,
            icon.progress_2,
            icon.progress_3,
            icon.progress_4,
            icon.progress_5,
            icon.progress_6,
            icon.progress_7,
            icon.progress_8,
            icon.progress_9,
          }
        ),
      },
      diagnostic = {
        enabled = true,
      },
      output = {
        enabled = true,
        open_on_run = false,
      },
      status = {
        enabled = true,
      },
    }
  end,
}
