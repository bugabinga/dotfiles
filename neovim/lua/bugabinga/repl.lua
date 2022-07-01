local want = require 'bugabinga.std.want'
want {
  'iron.core',
  'iron.view',
}(function(core, view)
  core.setup {
    config = {
      -- If iron should expose `<plug>(...)` mappings for the plugins
      should_map_plug = false,
      -- Whether a repl should be discarded or not
      scratch_repl = true,
      repl_open_cmd = view.curry.right(80),
      -- how the REPL window will be opened, the default is opening
      -- a float window of height 40 at the bottom.
    },
    -- Iron doesn't set keymaps by default anymore. Set them here
    -- or use `should_map_plug = true` and map from you vim files
    -- FIXME: setup own keybinds
    keymaps = {
      send_motion = '<space>sc',
      visual_send = '<space>sc',
      send_file = '<space>sf',
      send_line = '<space>sl',
      send_mark = '<space>sm',
      mark_motion = '<space>mc',
      mark_visual = '<space>mc',
      remove_mark = '<space>md',
      cr = '<space>s<cr>',
      interrupt = '<space>s<space>',
      exit = '<space>sq',
      clear = '<space>cl',
    },
    -- If the highlight is on, you can change how it looks
    -- For the available options, check nvim_set_hl
    highlight = {
      italic = true,
    },
  }
end)
