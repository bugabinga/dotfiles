local map = require("std.map")

map.normal({
  description = "Toggle Tree Join/Split",
  category = "editing",
  -- WARN: <C-j> produces the same keycode as <C-enter> on some terminals
  keys = "<C-j>",
  command = function()
    require("treesj").toggle()
  end,
})

return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = { use_default_keymaps = false },
}
