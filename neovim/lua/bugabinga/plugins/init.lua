local paq = require 'bugabinga.plugins.install'
paq {
  -- allow paq to manage itself
  'savq/paq-nvim',
  -- caches other plugins for faster startup
  'lewis6991/impatient.nvim',
  -- faster implementation of filetypes.vim
  'nathom/filetype.nvim',
  -- Utilities used by some plugins, e.g. telescope
  'nvim-lua/plenary.nvim',
  -- collection of icons used by other plugins. needs a nerd font
  'kyazdani42/nvim-web-devicons',
  -- fuzzy search ui over many parts of neovim and other plugins
  'nvim-telescope/telescope.nvim',
  -- use telescope as `vim.ui.select`
  'nvim-telescope/telescope-ui-select.nvim',
  -- use telescope as `vim.ui.input`
  'stevearc/dressing.nvim',
  -- display cheat sheet with telesope
  'nvim-telescope/telescope-cheat.nvim',
  -- show file browser in telescope
  'nvim-telescope/telescope-file-browser.nvim',
  -- manage projects via telescope
  'nvim-telescope/telescope-project.nvim',
  -- pick a symbol (emoji, icon, kaomoji,...) via telescope
  'nvim-telescope/telescope-symbols.nvim',
  -- visual indicator if code actions are available
  'kosayoda/nvim-lightbulb',
  -- some bug fix for LSP
  'antoinemadec/FixCursorHold.nvim',
  -- allows statusbar plugins to query LSP
  'nvim-lua/lsp-status.nvim',
  -- keybindings api that integrates into telescope to make keymaps searchable
  'gfeiyou/command-center.nvim',
  -- search and replace
  'nvim-pack/nvim-spectre',
  -- automatically manage window sizes based on focus
  'beauwilliams/focus.nvim',
  -- avoid jitter in buffers when windows change
  'luukvbaal/stabilize.nvim',
  -- keybindings that require a persistent chain
  'anuvyklack/hydra.nvim',
  -- extends hydra with pink heads
  'anuvyklack/keymap-layer.nvim',
  -- configure some editor settings according to editorconfig file, if present
  'gpanders/editorconfig.nvim',
  -- highlight words under cursor
  -- "RRethy/vim-illuminate",
  -- highlight matched wors more clearly
  'kevinhwang91/nvim-hlslens',
  -- draw lines to indicate indentation levels
  'lukas-reineke/indent-blankline.nvim',
  -- move blocks of code around
  'booperlv/nvim-gomove',
  -- theme with colors i like
  'rockerBOO/boo-colorscheme-nvim',
  -- display the colorcolumn as a virtual character
  'lukas-reineke/virt-column.nvim',
  -- jump cursor to last known position on neovim start
  'ethanholz/nvim-lastplace',
  -- smooth scrolling for movement
  'declancm/cinnamon.nvim',
  -- fast navigation in buffer via shortcut labels
  'ggandor/leap.nvim',
  -- breadcrumbs in window bar
  'SmiteshP/nvim-navic',
  -- show color values inline
  -- this plugins seems a little unmaintained right now.
  -- using some forks for now
  'NvChad/nvim-colorizer.lua',
  -- intelligent commenting
  'numToStr/Comment.nvim',
  -- show git status in ui
  'lewis6991/gitsigns.nvim',
  -- sexy start page
  'goolord/alpha-nvim',
  -- extend vim.notify with fancy ui
  'rcarriga/nvim-notify',
  -- show registers ui
  'tversteeg/registers.nvim',
  -- markdown editor
  -- 'jakewvincent/mkdnflow.nvim',
  -- highlight TODOs and collect them
  'folke/todo-comments.nvim',
  -- centralized view for code issues
  'folke/trouble.nvim',
  -- faster access to terminal
  'akinsho/toggleterm.nvim',
  -- File Browser
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
  },
  -- ui elements for other plugins
  'MunifTanjim/nui.nvim',
  -- window picker component for other plugins
  {
    's1n7ax/nvim-window-picker',
    branch = 'v1.3',
  },
  -- clipboard/yank history
  'AckslD/nvim-neoclip.lua',
  -- the treesitter parser is not compatible with current nushell for now
  -- {
  -- 	'LhKipp/nvim-nu',
  -- 	run = function() require'nvim-treesitter.install'.ensure_installed('nu') end,
  -- },
  -- smart parser for syntax
  {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update()
    end,
  },
  -- extend treesittier with light refactorings
  'nvim-treesitter/nvim-treesitter-refactor',
  -- add movement around structural syntax elements
  'nvim-treesitter/nvim-treesitter-textobjects',
  -- expand selection based on structure
  'RRethy/nvim-treesitter-textsubjects',
  -- highlight function arguments
  'm-demare/hlargs.nvim',
  -- inspect treesitter queries and get helpful functions
  'nvim-treesitter/playground',
  -- set commentstring when in polyglot files
  'JoosepAlviste/nvim-ts-context-commentstring',
  -- generate doc comment boilerplate
  'danymat/neogen',
  -- automatically change corresponding tag, when editing markup (xml/html)
  'windwp/nvim-ts-autotag',
  -- autoclose pairs on enter and completion
  'windwp/nvim-autopairs',
  -- glue, that binds all the neovim lsp crap
  'VonHeikemen/lsp-zero.nvim',
  -- LSP Support
  'neovim/nvim-lspconfig',
  'williamboman/nvim-lsp-installer',
  'simrat39/symbols-outline.nvim',
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lsp-document-symbol',
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lua',
  -- Snippets
  'L3MON4D3/LuaSnip',
  'rafamadriz/friendly-snippets',
  -- rust development
  'simrat39/rust-tools.nvim',
  -- java development
  'mfussenegger/nvim-jdtls',
  -- lua neovim config development
  'folke/lua-dev.nvim',
  -- fake lsp to pipe in non-lsp tools, like formatters, into lsp api
  'jose-elias-alvarez/null-ls.nvim',
  -- Special Java LSP integration sauce
  'mfussenegger/nvim-jdtls',
  -- debug adapter protocol
  'mfussenegger/nvim-dap',
  -- repls in neovim
  'hkupty/iron.nvim',
  -- color picker
  'ziontee113/color-picker.nvim',
  -- motions around object
  'kylechui/nvim-surround',
}
-- local plugins. they may override plugins from above
vim.opt.runtimepath:append '~/Workspace/lsp-zero.nvim'
return paq
