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

* pandoc with lua filters for diagrams for generating documents and previewing --> https://github.com/tex/vimpreviewpandoc
* think about mini.colors + nugu + nushell
* use gen.ai to generate docs
* learn marks and refactor mark.lua
* use ltex-ls for markdown, code comments and commit messages
* setup DAP
* add nu-check to nvim-lint
* create facade over vim.api.nvim_create_user_command
* create skelleton-plugin for default file content based on file type
* add support for Java mutliline string in autopairs
* nvim spell for camelcase words
