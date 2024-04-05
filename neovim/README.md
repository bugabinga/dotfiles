# bugabinga neovim config

neovim configuration is scripting.
scripting with lua + neovim api is programming.

## project structure

init.lua
: main entry point
lua/std
: standard lib. can only depend on itself and neovim apis.
lua/bugabinga
: config modules. in aggregation, defines all of the config. can depend on itself, std and plugins.
lua/bugabinga/plugins
: third party plugins and their config glue integrating it into the config.
colors/nugu
: color theme
ftplugin
: file type specific config

----------

# ai poem

I am the bone of my code, bugs are my body and exceptions are my blood.
I have created over a thousand bugs, unknown to testers, nor known to debuggers.
Have withstood pain to create many programs, yet those hands will never hold a working program.
So as I pray, Unlimited Bug Works.

~ Shirou Emiya

# todo

* toggling case conventions
* Move to treesitter main branch
* check out `vim.snippet`
* use `vim.base64` in wezterm plugin
* Bug: LuaLS is getting crazy diagnosing non-stop...
* integrate language tool?
* ]s [s to jump to spelling mistakes
* learn marks and refactor mark.lua
* try Termdebug with gdb
* adapt config to respect `vim.g.nerdfont` (std.constants?)
* use ltex-ls for markdown, code comments and commit messages
* learn from <https://github.com/stevearc/dotfiles/blob/master/.config/nvim/plugin/exrc.lua> and maybe adapt `std.localrc`
* setup DAP
* nvim spell for camel case words
* add nu-check to nvim-lint
* create skeleton-plugin for default file content based on file type (BufNewFile?)
* make lsp config extensible, so that plugin configs can hook into it (e.g. on_attach)
* split parts of config into plugins
* add support for Java multi line string in autopairs
* pandoc with lua filters for diagrams for generating documents and previewing --> https://github.com/tex/vimpreviewpandoc
  outside of vim?
