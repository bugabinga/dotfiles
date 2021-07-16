-- This module installs a plugin manager `packer`, that provides a
-- convenient API over the nvim package feature.
-- After installation, `packer` is configured to load all my favorite nvim plugins.
-- The module plugins extends packer via a metatable that delegates all calls from plugin to packer.
-- This way we can pretend that plugins do all the work and fine tune packer configuration.
--
-- autocommand:function    => API to create vim autocmds
-- data_path:string        => root directory into which packer can be installed, if not already done
-- non_interactive:boolean => wether to show a display when updating plugins or not. Typically set to true, when nvim is used for scripting.
return function(autocommand, data_path, non_interactive)
  local plugin_package = 'plugins'
  -- packer will be loaded into the optionals folder and loaded later on demand by `packadd packer.nvim`
  -- glob will normalize the path with respect to path separators.
  -- mixing those seems to sometimes trip up packer, though the reason is unknown.
  local packer_installation_path = vim.fn.glob(
    data_path .. '/site/pack/' .. plugin_package .. '/opt/packer.nvim'
  )
  if vim.fn.empty(packer_installation_path) == 1 then
    vim.cmd(
      '!git clone https://github.com/wbthomason/packer.nvim "'
      .. packer_installation_path
      .. '"'
    )
  end
  local packer = nil
  local init = function()
    -- lazy init the loading and configuration of packer
    if packer == nil then
      packer = require 'packer'
      packer.init {
        -- Do not create vim commands, because we will create our own, that delegate to the plugins module
        disable_commands = true,
        plugin_package = plugin_package,
        display = {
          non_interactive = non_interactive,
          open_fn = require('packer.util').float,
        },
        profile = {
          enable = true,
          threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
        },
      }
    end
    autocommand{ compile_plugin_glue = 'BufWritePost plugins.lua PluginsCompile' }
    local use = packer.use
    -- reset packer in case we are reloading the whole configuration
    packer.reset()

    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', opt = true }
    -- Closes brackets automatically upon hitting Enter
    use 'rstacruz/vim-closer'
    -- Nice file tree browser
    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        vim.g.nvim_tree_side = 'left'
        vim.g.nvim_tree_width = 42
        vim.g.nvim_tree_auto_open = 1
        vim.g.nvim_tree_ignore_ft = {'cheatsheet'}
      end,
    }
    -- NVIM API for defining color schemes
    -- TODO: when profiling, this plugins loading times are high
    --       maybe the cause is that it loads a bunch of files
    --       should those be merged into one file?
    use {
      'tjdevries/colorbuddy.vim',
      config = function()
        require'theme'(require'colorbuddy'.setup())
      end,
    }
    -- Advanced parsers for better syntax highlighting
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdateSync',
      config = function()
        require'nvim-treesitter.install'.compilers = {"clang"}
        require'nvim-treesitter.configs'.setup{
          ensure_installed = 'maintained',
          highlight = { enable = true },
          incremental_selection = { enable = true },
          indent = { enable = true },
          query_linter = { enable = true },
        }
      end,
    }
    use { 'nvim-treesitter/playground', run = ':TSInstall query' }
    -- Basic integration of ziglang
    use { 'ziglang/zig.vim', opt = true, ft = 'zig' }
    -- Move around the buffer with easy motions
    use 'phaazon/hop.nvim'
    -- Show the actual color of color codes and names
    -- #f00    => red
    -- #00ff00 => green
    -- Blue    => blue
    --
    use {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require'colorizer'.setup()
      end,
    }
    -- An attempt to clone magit
    use { 'TimUntersberger/neogit', opt= true, cmd = 'Neogit' }
    -- Fuzzy matcher
    use {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    }
    -- Render markdown previews in the terminal
    use { 'npxbr/glow.nvim', opt = true, cmd = 'Glow' }
    -- Type :<number> to jump to line numbers
    use {
      'nacro90/numb.nvim',
      config = function()
        require'numb'.setup{
          show_numbers = false,
          show_cursorline = true,
        }
      end,
    }
    -- Repository and API for configuring LSP servers in nvim
    use { 'neovim/nvim-lspconfig', config = function()
      require'lsp'()
    end}
    -- Utility functions to glue the status messages of LSP servers with the status line in nvim together
    use 'nvim-lua/lsp-status.nvim'
    -- Deeper integration of JDTLS from Eclipse with nvim
    -- DO NOT use simultanously with jdtls from lspconfig!
    -- TODO: integrate with nvim-dap debugger
    -- use { 'mfussenegger/nvim-jdtls', opt = true }
    -- Completions support, that integrates advanced nvim features (LSP+treesitter)
    use { 'nvim-lua/completion-nvim' }
    -- trim trailing whitespace on save
    use {
      'cappyzawa/trim.nvim',
      config = function()
        require'trim'.setup{
          disable = {"markdown"}
        }
      end,
    }
    -- comment and uncomment lines
    use {
      'b3nj5m1n/kommentary',
      config = function()
        cheatsheet'Use gcc to toggle line comment'
      end,
    }
    -- smooth scrolling
    -- TODO: configure mappings to overide duration
    --       currently the scroll steps a pretty slow
    use {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup({
          -- All these keys will be mapped. Pass an empty table ({}) for no mappings
          mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
          hide_cursor = true,          -- Hide cursor while scrolling
          stop_eof = true,             -- Stop at <EOF> when scrolling downwards
          respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
          cursor_scrolls_alone = true,  -- The cursor will keep on scrolling even if the window cannot scroll further
          easing_function = 'circular', -- Interpolation of scroll animation steps
        })
      end,
    }
    -- fancy status line below
    use {
      'hoob3rt/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        require'lualine'.setup{
          options = {
            theme = 'modus_vivendi',
            icons_enabled = true,
            extensions = { 'nvim-tree', 'quickfix' }
          },
          sections = { lualine_c = { "os.data('%a')", 'data', require'lsp-status'.status } }
        }
      end,
    }
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
