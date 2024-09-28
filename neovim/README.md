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

---

# ai poem

I am the bone of my code, bugs are my body and exceptions are my blood.
I have created over a thousand bugs, unknown to testers, nor known to debuggers.
Have withstood pain to create many programs, yet those hands will never hold a
working program.
So as I pray, Unlimited Bug Works.

~ Shirou Emiya

# todo

* indent line bg overwrites visual selection bg
* fix bg highlight of treesitter-context
* fix markdown rendering in doc popup
* make highlights more visible when expanding snippets
* kill mason again and get lsps via packages.nu
* simplify lsp config
    - make my config identical to vim.lsp.ClientConfig
    - fuck all that single file and workspace stuff
    - move start function and config creation from lsp/init.lua to ftplugin/*.lua
* make assignment to map.x fail, e.g. `map.normal = {}`...
* figure out desirable cmp key maps
* try loading lsp async for better startup perf
* check out `vim.snippet`
* replace cmp with vim.lsp.completion when 0.11 comes out
* adapt config to respect `vim.g.nerdfont` (std.const?)
* check out harper-ls
* check out ast-grep
* nvim spell for camel case words
* create skeleton-plugin for default file content based on file type
  (BufNewFile?)
* make lsp config extensible, so that plugin configs can hook into it (e.g.
  on_attach)
* add support for Java multi line string in autopairs
