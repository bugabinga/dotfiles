-- set <SPACE> as leader key
vim.keymap.set('', '<SPACE>', '<NOP>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable default ENTER binding
vim.keymap.set('', '<CR>', '<NOP>', { silent = true })

-- disable command history keymap, because i fatfinger it too often
-- FIXME: these seem to disable the binding only partially.
-- when pressing q: "fast", it is disabled.
-- when pausing between q and :, the binding still opens command history.
-- this may be relatred to the timeoutlen setting?
vim.keymap.set('', 'q:', '<NOP>', { silent = true })
vim.keymap.set('', 'q/', '<NOP>', { silent = true })
vim.keymap.set('', 'Q', '<NOP>', { silent = true })

-- disable them evil arrows
vim.keymap.set('', '<Up>', '<NOP>', { silent = true })
vim.keymap.set('', '<Down>', '<NOP>', { silent = true })
vim.keymap.set('', '<Left>', '<NOP>', { silent = true })
vim.keymap.set('', '<Right>', '<NOP>', { silent = true })
