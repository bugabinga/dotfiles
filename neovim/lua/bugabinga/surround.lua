local want = require 'bugabinga.std.want'
want { 'nvim-surround' }(function(surround)
  surround.setup {
		insert = "ys",
		insert_line = "yss",
		-- this thing does seemingly nothing?
		-- visual = "<CR>",
		delete = "ds",
		change = 'cs',
  }
end)
