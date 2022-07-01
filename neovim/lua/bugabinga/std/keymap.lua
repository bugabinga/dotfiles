-- this is a facade API over keybindings, so that i can more freely experiments
-- with different plugins and newer neovim APIs.
--
-- this module returns 2 functions.
-- the first takes a keybinding and collects them.
-- the second function converts the declared keybindings into actual mappings
-- neovim and other plugins.
--
-- a keybinging is expected to have the following structure:
-- {
--	name = "Open Command Center",
--	description = "Opens the Command Center with Telescope to show all available keybound commands.",
--	category = nil,
--	mode = "n",
--	map = "<C-P>",
--	map_options = { silent = true, noremap = true },
--	command = function() require'telescope'.run("command_center") end,
-- }
--
-- use the first function throughout the configuration to declare keybindings.
-- call the second function at the end of the configuration to actually apply
-- the keybindings to the system.

local want = require 'bugabinga.std.want'

local keybindings = {}

local function add(keybinding)
  table.insert(keybindings, keybinding)
end

-- the goal of this function is to process a list of keybinds.
-- those keybinds need to:
-- * be added to Command Center
-- * be transformed into a tree and feed to the Hydra
-- * left-over keybinds, that do not form a tree, need to be mapped manually
local function build()
  -- registering keybinds in command center.
  -- this will NOT YET apply the keymap in neovim.
  want { 'command_center' }(function(command_center)
    local converted_bindings_for_command_center = {}
    --example of a command-center keybind table
    --{
    --    description = "Open git diffview",
    --    cmd = "<CMD>DiffviewOpen<CR>",
    --    keybindings = { "n", "<leader>gd", noremap },
    --    category = "git",
    --  }
    for _, keybind in pairs(keybindings) do
      local converted = {
        description = keybind.description,
        category = keybind.category,
        cmd = keybind.command,
        keybindings = { keybind.mode, keybind.map, keybind.map_options },
      }
      table.insert(converted_bindings_for_command_center, converted)
    end
    command_center.add(converted_bindings_for_command_center, command_center.mode.ADD_ONLY)
  end)

  -- FIXME feed the beast!

  -- Manually map the left-over keybindings with the neovim api.
  -- It is assumed, that all keybinds eaten by the Hydra are removed from
  -- `keybindings`.

  for _, keybind in pairs(keybindings) do
    vim.keymap.set(keybind.mode, keybind.map, keybind.command, keybind.map_options)
  end
end

return {
  add = add,
  build = build,
}
