-- This function configures all the LSP clients that i might care about.
-- It is expected to be called in the 'config' step of the 'lspconfig' plugin.
-- autocommand: function, that can create autocmds
return function()
	local integrate_into_neovim = function(client, buffer_number)
		print("LSP " .. client.name .. " [" .. client.id .. "] " .. "started.")

		-- enable lsp-powered auto-completion
		-- FIXME: I cannot seem to configure this plugin to my liking.
		require("completion").on_attach()
		-- adds icons into the completion ui
		require"lspkind".init()

		-- hook lsp into vim autocomplete in insert mode
		vim.api.nvim_buf_set_option(buffer_number, "omnifunc", "v:lua.vim.lsp.omnifunc")

		local map = function(type, key, value)
			vim.api.nvim_buf_set_keymap(buffer_number, type, key, value, { noremap = true, silent = true })
		end

		map("n", "<LEADER>gD", "<CMD>lua vim.lsp.buf.declaration()<CR>")
		map("n", "<LEADER>gd", "<CMD>lua vim.lsp.buf.definition()<CR>")
		map("n", "<LEADER>gr", "<CMD>lua vim.lsp.buf.references()<CR>")
		map("n", "<LEADER>gi", "<CMD>lua vim.lsp.buf.implementation()<CR>")
		map("n", "<LEADER>gt", "<CMD>lua vim.lsp.buf.type_definition()<CR>")
		map("n", "<LEADER>gw", "<CMD>lua vim.lsp.buf.document_symbol()<CR>")
		map("n", "<LEADER>gW", "<CMD>lua vim.lsp.buf.workspace_symbol()<CR>")

		map("n", "<LEADER>ah", "<CMD>lua vim.lsp.buf.hover()<CR>")
		map("n", "<LEADER>as", "<CMD>lua vim.lsp.buf.signature_help()<CR>")
		map("n", "<LEADER>af", "<CMD>lua vim.lsp.buf.code_action()<CR>")
		map("n", "<LEADER>ar", "<CMD>lua vim.lsp.buf.rename()<CR>")
		map("n", "<LEADER>a=", "<CMD>lua vim.lsp.buf.formatting()<CR>")
		map("n", "<LEADER>ai", "<CMD>lua vim.lsp.buf.incoming_calls()<CR>")
		map("n", "<LEADER>ao", "<CMD>lua vim.lsp.buf.outgoing_calls()<CR>")

		map("n", "<LEADER>n", "<CMD>lua vim.lsp.diagnostic.goto_next()<CR>")
		map("n", "<LEADER>N", "<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>")
		map("n", "<LEADER><LEADER>", "<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
	end

	local lsp = require("lspconfig")

	-- Nvim lua configuration LSP
	local neovim_runtime_path = vim.split(package.path, ";")
	table.insert(neovim_runtime_path, "lua/?.lua")
	table.insert(neovim_runtime_path, "lua/?/init.lua")

	local system_name
	if vim.fn.has("mac") == 1 then
		system_name = "macOS"
	elseif vim.fn.has("unix") == 1 then
		system_name = "Linux"
	elseif vim.fn.has("win32") == 1 then
		system_name = "Windows"
	else
		print("Unsupported system for sumneko")
	end
	local neovim_lua_library = {}
	for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
		local lua_path = path .. "/lua/"
		if vim.fn.isdirectory(lua_path) then
			neovim_lua_library[lua_path] = true
		end
	end
	local sumneko_home = "~/Workspace/sua-language-server"
	if system_name == "Windows" then
		sumneko_home = "W:/misc/lua-language-server"
	end
	-- This loads the `lua` files from nvim into the runtime.
	neovim_lua_library[vim.fn.expand("$VIMRUNTIME/lua")] = true
	--TODO: How to switch this configuration based upon if we are editing neovim configuration or just any Lua file/project?
	lsp.sumneko_lua.setup({
		on_attach = integrate_into_neovim,
		cmd = {
			sumneko_home .. "/bin/" .. system_name .. "/lua-language-server",
			"-E",
			"-W",
			sumneko_home .. "/main.lua",
		},
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = neovim_runtime_path,
				},
				diagnostics = {
					enable = true,
					disable = "trailing-space",
					globals = { "vim" },
				},
				hint = {
					enable = true,
				},
				workspace = {
					library = neovim_lua_library,
					maxPreload = 10000,
					preloadFileSize = 10000,
				},
				telemetry = {
					enable = true,
				},
				globals = {
					"cheatsheet",
				},
			},
		},
	})

	-- Markdown Notes (Zettelkasten) LSP
	lsp.zeta_note.setup({
		on_attach = integrate_into_neovim,
		cmd = { "zeta-note" },
	})

	-- YAML LSP
	lsp.yamlls.setup({
		on_attach = integrate_into_neovim,
		--FIXME: Only works on Windows
		cmd = { "yaml-language-server.cmd", "--stdio" },
		root_dir = function()
			return vim.fn.getcwd()
		end,
	})

	-- Zig LSP
	-- FIXME: ZLS is very tied to the specific version of the zig compiler one uses.
	-- we need to build our own version for 0.8.0 because it is not done upstream yet
	-- lsp.zls.setup({ on_attach = integrate_into_neovim })

	-- LLVM Clang LSP
	lsp.clangd.setup({ on_attach = integrate_into_neovim })

	-- JSON LSP
	lsp.jsonls.setup({
		on_attach = integrate_into_neovim,
		--FIXME: Only works on Windows
		cmd = { "vscode-json-language-server.cmd", "--stdio" },
		commands = {
			Format = {
				-- Apply the ranged formatting to the whole file
				function()
					vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
				end,
			},
		},
	})

	-- GraphViz Dot LSP
	lsp.dotls.setup({ on_attach = integrate_into_neovim })

	-- Null-ls
	local nls = require("null-ls")
	local helpers = require("null-ls.helpers")
	local methods = require("null-ls.methods")
	local prose_format = helpers.make_builtin({
		method = methods.internal.FORMATTING,
		filetypes = { "markdown" },
		generator_opts = {
			command = "prose",
			--FIXME this should be a higher order function, because the tab width needs to be lazily fetched at callsite and for the buffer instead of the global value.
			args = { "-f", "-w", "80", "-m", "-t", vim.o.tabstop },
			to_stdin = true,
		},
		factory = helpers.formatter_factory,
	})
	nls.setup({
		debug = false,
		-- Format: [CODE] MESSAGE (SOURCE)
		diagnostics_format = "[#{c}] #{m} (#{s})",
		sources = {
			nls.builtins.formatting.stylua,
			prose_format,
			-- this is a nice linter, but wihtout configuration, it spews too much nonsense.
			-- one can define the stdlib for vim in a config file, but the builtin selene does not find the config file.
			-- this is a general issue with formatters/linters integrated into neovim.
			-- how should i handle this?
			-- write a function, that searches the path to root for a config file? (internal stylua behaviour)
			-- somehow make sure, that vim root folder is always correct...?
			-- nls.builtins.diagnostics.selene,
		},
		on_attach = integrate_into_neovim,
	})
end
