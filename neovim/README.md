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

# ai poem

I am the bone of my code, bugs are my body and exceptions are my blood.
I have created over a thousand bugs, unknown to testers, nor known to debuggers.
Have withstood pain to create many programs, yet those hands will never hold a working program.
So as I pray, Unlimited Bug Works.

~ Shirou Emiya

---------

# todo

* replace nugu with nugu_fresh
* write plugin to parse lsp settings locally and apply them
* is there a use case for a plugin that parses local plugin configuration overrides?
* kill custom lsp stuff in favor of lspconfig and try neoconf + nvim-java
* does status bar fail to display if lsp fails to load?
* pandoc with lua filters for diagrams for generating documents and previewing --> https://github.com/tex/vimpreviewpandoc
* use gen.ai to generate docs
* learn marks and refactor mark.lua
* use ltex-ls for markdown, code comments and commit messages
* create a floating window that shows plugins, that have commands, as reminder
* setup DAP
* add nu-check to nvim-lint
* create facade over vim.api.nvim_create_user_command
* create skeleton-plugin for default file content based on file type
* add support for Java multi line string in autopairs
* nvim spell for camel case words
