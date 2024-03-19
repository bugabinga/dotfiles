local map = require 'std.map'

return {
  'lewis6991/gitsigns.nvim',
  tag = 'v0.7',
  event = 'VeryLazy',
  opts = {
    signs = {
      add          = { text = '│', },
      change       = { text = '│', },
      delete       = { text = '_', },
      topdelete    = { text = '‾', },
      changedelete = { text = '~', },
      untracked    = { text = '┆', },
    },
    preview_config = {
      border = vim.g.border_style,
    },
    current_line_blame = true,
    current_line_blame_opts = {
      ignore_whitespace = true,
    },
    current_line_blame_formatter = '<author>(<author_time:%d.%m.%Y>): <summary>',
    on_attach = function ( bufnr )
      local gitsigns = require 'gitsigns'

      map.normal {
        description = 'Goto next hunk',
        category = 'git',
        keys = ']h',
        buffer = bufnr,
        command = gitsigns.next_hunk,
      }

      map.normal {
        description = 'Goto previous hunk',
        category = 'git',
        keys = '[h',
        buffer = bufnr,
        command = gitsigns.prev_hunk,
      }

      map.normal {
        description = 'Stage hunk',
        category = 'git',
        keys = '<leader>hs',
        buffer = bufnr,
        command = gitsigns.stage_hunk,
      }

      map.visual_select {
        description = 'Stage hunk',
        category = 'git',
        keys = '<leader>hs',
        buffer = bufnr,
        command = function () gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v', } end,
      }

      map.normal {
        description = 'Reset hunk',
        category = 'git',
        keys = '<leader>hr',
        buffer = bufnr,
        command = gitsigns.reset_hunk,
      }

      map.visual_select {
        description = 'Reset hunk',
        category = 'git',
        keys = '<leader>hr',
        buffer = bufnr,
        command = function () gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v', } end,
      }

      map.normal {
        description = 'Undo stage hunk',
        category = 'git',
        keys = '<leader>hu',
        buffer = bufnr,
        command = gitsigns.undo_stage_hunk,
      }

      map.normal {
        description = 'Stage buffer',
        category = 'git',
        keys = '<leader>hS',
        buffer = bufnr,
        command = gitsigns.stage_buffer,
      }

      map.normal {
        description = 'Reset buffer',
        category = 'git',
        keys = '<leader>hR',
        buffer = bufnr,
        command = gitsigns.reset_buffer,
      }

      map.normal {
        description = 'Preview hunk',
        category = 'git',
        keys = '<leader>hp',
        buffer = bufnr,
        command = gitsigns.preview_hunk,
      }

      map.normal {
        description = 'Blame line',
        category = 'git',
        keys = '<leader>hb',
        buffer = bufnr,
        command = function () gitsigns.blame_line { full = true, } end,
      }

      map.normal {
        description = 'Diff this',
        category = 'git',
        keys = '<leader>hd',
        buffer = bufnr,
        command = gitsigns.diffthis,
      }

      map.normal {
        description = 'Diff this ~',
        category = 'git',
        keys = '<leader>hD',
        buffer = bufnr,
        command = function () gitsigns.diffthis '~' end,
      }

      map.normal {
        description = 'Toggle current line blame',
        category = 'git',
        keys = '<leader>tb',
        buffer = bufnr,
        command = gitsigns.toggle_current_line_blame,
      }

      map.normal {
        description = 'Toggle removed lines',
        category = 'git',
        keys = '<leader>tr',
        buffer = bufnr,
        command = gitsigns.toggle_deleted,
      }

      map.operator_pending.visual {
        description = 'select hunk',
        category = 'git',
        keys = 'ih',
        buffer = bufnr,
        command = ':<C-U>Gitsigns select_hunk<CR>',
      }
    end,
  },
}
