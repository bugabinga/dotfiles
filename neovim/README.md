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
: config modules, that in aggregation, define all of the configuration and may
only depend on itself, std and plugins.
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
Have withstood pain to create many programs, yet those hands will never hold a
working program.
So as I pray, Unlimited Bug Works.

~ Shirou Emiya

# todo

* navic highlights do not fit winbar
* indent line bg overwrites visual selection bg
* fix bg gihlight of treesitter-context
* make highlights more visible when expanding snippets
* make assignment to map.x fail, e.g. `map.normal = {}`...
* figure out desirable cmp key maps
* try loading lsp async for better startup perf
* check out `vim.snippet`
* adapt config to respect `vim.g.nerdfont` (std.constants?)
* Do I want multiple LSPs per buffer?
  In case of markdown and text it seems useful, for code it seems like a
  headache...
  But it seems inevitable, because more and more tools use the LSP infrastructure.
  For example, grammar checkers like harper or code transform tools like ast-grep
* check out harper-ls
* check out ast-grep
* flesh out 'const.lua', move to std?
* nvim spell for camel case words
* create skeleton-plugin for default file content based on file type
  (BufNewFile?)
* make lsp config extensible, so that plugin configs can hook into it (e.g.
  on_attach)
* add support for Java multi line string in autopairs
