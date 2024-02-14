local table = require 'std.table'
local joinpath = vim.fs.joinpath

-- disable spell checking initially
vim.opt.spell = false
vim.opt.spellcapcheck = ''
-- English, German, Polish and tech words
vim.opt.spelllang:append 'en'
vim.opt.spelllang:append 'de'
vim.opt.spelllang:append 'pl'
vim.opt.spelllang:append 'nerd'
local config_dir = vim.fn.stdpath 'config'
---@diagnostic disable-next-line: param-type-mismatch
local spell_dir = joinpath( config_dir, 'spell' )
vim.opt.spellfile = table.concat(
  {
    joinpath( spell_dir, 'nerd.utf-8.add' ),
    joinpath( spell_dir, 'en.utf-8.add' ),
    joinpath( spell_dir, 'de.utf-8.add' ),
    joinpath( spell_dir, 'pl.utf-8.add' ),
  }, ',' )

-- create new spl file with:
-- mkspell ~/.config/nvim/spell/[lang] ~/Downloads/[lang]
-- update nerd words with
-- mkspell! ~/.config/nvim/spell/nerd ~/.config//nvim/spell/nerd.words
