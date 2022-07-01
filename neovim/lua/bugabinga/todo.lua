local want = require 'bugabinga.std.want'
want { 'todo-comments' }(function(todo)
  -- HACK: #104 Invalid in command-line window
  local hl = require 'todo-comments.highlight'
  local highlight_win = hl.highlight_win
  hl.highlight_win = function(win, force)
    pcall(highlight_win, win, force)
  end
  todo.setup {}
end)
