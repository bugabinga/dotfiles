-- This module installs a plugin manager `packer`, that provides a
-- convenient API over the nvim package feature.
-- After installation, `packer` is configured to load all my favorite nvim plugins.
-- The module plugins extends packer via a metatable that delegates all calls from plugin to packer.
-- This way we can pretend that plugins do all the work and fine tune packer configuration.
--
-- autocommand:function    => API to create vim autocmds
-- data_path:string        => root directory into which packer can be installed, if not already done
-- non_interactive:boolean => wether to show a display when updating plugins or not. Typically set to true, when nvim is used for scripting.
return function(data_path, non_interactive)
	local plugin_package = "plugins"
	-- packer will be loaded into the optionals folder and loaded later on demand by `packadd packer.nvim`
	-- glob will normalize the path with respect to path separators.
	-- mixing those seems to sometimes trip up packer, though the reason is unknown.
	local packer_installation_path = data_path .. "/site/pack/" .. plugin_package .. "/opt/packer.nvim"
	if vim.fn.empty(vim.fn.glob(packer_installation_path)) == 1 then
		vim.cmd('!git clone https://github.com/wbthomason/packer.nvim "' .. packer_installation_path .. '"')
		vim.cmd("packadd packer")
	end
	local packer = nil
	local init = function()
		-- lazy init the loading and configuration of packer
		if packer == nil then
			packer = require("packer")
			packer.init({
				-- Do not create vim commands, because we will create our own, that delegate to the plugins module
				disable_commands = true,
				plugin_package = plugin_package,
				display = {
					non_interactive = non_interactive,
				},
				profile = {
					enable = false,
					threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
				},
			})
		end
		local use = packer.use
		-- reset packer in case we are reloading the whole configuration
		packer.reset()

		-- Packer can manage itself
		use({ "wbthomason/packer.nvim", opt = true })

		-- Display popup with possible keybindings to a command
		use({
			"folke/which-key.nvim",
			config = function()
				local key_labels = { ["<SPACE>"] = "SPACE", ["<CR>"] = "ENTER", ["<TAB>"] = "TAB", ["."] = "DOT" }
				for f_key_number = 1, 12 do
					key_labels["<F" .. f_key_number .. ">"] = "F" .. f_key_number
				end

				require("which-key").setup({
					marks = true,
					registers = true,
					spelling = { enabled = true, suggestions = 5 },
					key_labels = key_labels,
					window = { border = "single" },
				})
			end,
		})

		-- Pretty abstraction over quicklist, loclist, messages and lsp diagnostics
		use({
			"folke/trouble.nvim",
			cmd = { "Trouble", "TroubleClose", "TroubleRefresh", "TroubleToggle" },
			requires = {
				{ "kyazdani42/nvim-web-devicons", opt = true },
				-- patches in some highlighting groups for LSP diagnostics
				-- FIXME should just be done by my theme instead of this plugin...
				{ "folke/lsp-colors.nvim" },
			},
			config = function()
				require("trouble").setup()
				require("lsp-colors").setup({
					Error = "#f05faf",
					Warning = "#c0af68",
					Information = "#2db8cf",
					Hint = "#19bc90",
				})
			end,
		})

		-- Treesitter syntax highlighting for justfiles
		use{"IndianBoy42/tree-sitter-just", config = function()
      require"tree-sitter-just".setup({["local"] = true})
		end}

		-- NVIM API for defining color schemes
		use({
			"tjdevries/colorbuddy.vim",
			config = function()
				require("theme")(require("colorbuddy").setup())
			end,
		})

		-- Advanced parsers for better syntax highlighting
		use({
			"nvim-treesitter/nvim-treesitter",
			requires = { "nvim-treesitter/nvim-treesitter-refactor" },
			config = function()
				require("nvim-treesitter.install").compilers = { "clang" }
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						-- "zig",
						"java",
						"rust",
						"lua",
						"toml",
						"yaml",
						"json",
						"jsonc",
						"c",
						-- "comment",
						"html",
						"css",
						"javascript",
						"query",
						"vim",
					},
					highlight = { enable = true },
					incremental_selection = {
						enable = false,
						keymaps = {
							init_selection = "<C-Up>",
							node_incremental = "<C-Up>",
							node_decremental = "<C-Down>",
							scope_incremental = "<A-Up>",
						},
					},
					indent = { enable = false },
					query_linter = { enable = false, use_virtual_text = true, lint_events = { "BufWrite" } },
					refactor = {
						highlight_definitions = { enable = false },
						smart_rename = { enable = false, keymaps = { smart_rename = "<LEADER>r" } },
						navigation = {
							enable = false,
							keymaps = { goto_next_usage = "<a-.>", goto_previous_usage = "<a-,>" },
						},
					},
				})
			end,
		})

		-- Treesitter Playground
		-- Show the treesitter parse tree.
		-- Lint syntax errors
		-- Show highlight groupsunder cursor
		use({
			"nvim-treesitter/playground",
			config = function()
				local keys = require("which-key")
				keys.register({
					["<space>."] = {
						"<CMD>TSHighlightCapturesUnderCursor<CR>",
						"Shows the highlight group under the cursor, when TreeSitter is used.",
					},
				})
			end,
		})

		-- Basic integration of ziglang
		use({ "ziglang/zig.vim", opt = true, ft = "zig" })

		-- Move around the buffer with easy motions
		use("phaazon/hop.nvim")

		-- Show the actual color of color codes and names
		-- #f00    => red
		-- #00ff00 => green
		-- Blue    => blue
		--
		use({
			"norcalli/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
		})

		-- Type :<number> to jump to line numbers
		use({
			"nacro90/numb.nvim",
			config = function()
				require("numb").setup({
					show_numbers = false,
					show_cursorline = true,
				})
			end,
		})

		-- null-ls is a plugin, that allows to code custom functions, that get exposed as a lsp server
		use({
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				-- This will configure all LSPs not only Null-ls.
				-- But because Null-ls depends on lspconfig, we have to delay this
				require("lsp")()
				-- overwrite default action handlers with cuter ones
				vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
				vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
				vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
				vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
				vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
				vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
				vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
				vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler
			end,
			requires = {
				-- dependecies of telescope
				-- extensions to the std lib
				"nvim-lua/plenary.nvim",
				-- popup windows
				"nvim-lua/popup.nvim",
				-- Fuzzy matcher
				"nvim-telescope/telescope.nvim",
				-- debugging adapter -- like LSP but for debuggers
				"mfussenegger/nvim-dap",
				-- advanced rust integration
				"simrat39/rust-tools.nvim",
				-- Preprepared collection of glue code for neovim lsp-client and thrid party lsp servers.
				"neovim/nvim-lspconfig",
				-- Completions support, that integrates advanced nvim features (LSP+treesitter)
				"norcalli/snippets.nvim",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-calc",
				"hrsh7th/cmp-emoji",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/nvim-cmp",
				-- Icons for completion UI
				"onsails/lspkind-nvim",
				-- dependency of nvim-lsputils
				"RishabhRD/popfix",
				-- collection of better handlers for lsp actions.
				-- e.g. puts selection of code actions into floating window
				"RishabhRD/nvim-lsputils",
			},
		})

		-- Deeper integration of JDTLS from Eclipse with nvim
		-- DO NOT use simultanously with jdtls from lspconfig!
		-- TODO: integrate with nvim-dap debugger
		-- use { 'mfussenegger/nvim-jdtls', opt = true }
		--

		-- comment and uncomment lines
		use({ "b3nj5m1n/kommentary" })

		-- smooth scrolling
		-- Its possible Neovide will support smooth scrool soon: https://github.com/neovim/neovim/issues/15075
		-- When it does, this plugin is redundant, if nvim runs in Neovide.
		use({
			"karb94/neoscroll.nvim",
			config = function()
				require("neoscroll").setup({
					-- All these keys will be mapped. Pass an empty table ({}) for no mappings
					mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
					hide_cursor = true, -- Hide cursor while scrolling
					stop_eof = true, -- Stop at <EOF> when scrolling downwards
					respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
					cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
					easing_function = "circular", -- Interpolation of scroll animation steps
				})
			end,
		})

		-- ASCII diagram drawing
		use({
			"jbyuki/venn.nvim",
			opt = true,
			command = "VBox",
		})

		-- Show outline view based on LSP
		use({ "simrat39/symbols-outline.nvim" })

		-- Make using terminals in Neovim more comfortable
		use({
			"numtostr/FTerm.nvim",
			config = function()
				require("FTerm").setup({ cmd = "nu", border = "single" })
			end,
		})

		-- automatically size splits reasonably
		use({
			"beauwilliams/focus.nvim",
			config = function()
				local focus = require("focus")
				focus.signcolumn = false
			end,
		})
	end

	-- the plugin module always delegates to packer, ensuring that at all times init configures packer correctly
	local plugins = setmetatable({}, {
		__index = function(_, key)
			init()
			return packer[key]
		end,
	})
	return plugins
end
