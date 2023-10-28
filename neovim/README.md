# bugabinga neovim config

neovim configuration is scripting.
scripting with lua + neovim api is programming.

## project structure

init.lua
: main entry point
\
lua/std
: standard lib. can only depend on itself and neovim apis.
\
lua/bugabinga
: config modules. in aggregation, defines all of the config. can depend on itself, std and plugins.
\
lua/bugabinga/plugins
: third party plugins and their config glue integrating it into the config.
\
colors/nugu
: color theme
\
ftplugin
: file type specific config

----------

# todo

* pandoc with lua filters for diagrams for generating documents and previewing --> https://github.com/tex/vimpreviewpandoc
* think about mini.colors
* setup spell checking for code (english + german)
* use gen.ai to generate docs
* learn marks and refac mark.lua
* use ltex-ls for markdown, code comments and commit messages
* setup DAP
* add nu-check to nvim-lint
* autocomplete in cmdline does not work no more
* make telescope highlights more like NormalFloat
* create facade over vim.api.nvim_create_user_command
* fix autocomplete in cmdline
* prompts from Mini*-Plugins tend to show up via notify. hard to read. how to change them all?
