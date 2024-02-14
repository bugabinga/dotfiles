local map = require 'bugabinga.std.keymap'
local project = require 'bugabinga.std.project'
local want = require 'bugabinga.std.want'

want { 'todo-comments' }(function(todo)
  -- HACK: #104 Invalid in command-line window
  local hl = require 'todo-comments.highlight'
  local highlight_win = hl.highlight_win
  hl.highlight_win = function(win, force)
    pcall(highlight_win, win, force)
  end
  todo.setup {}

  map{
  	description = 'Show all To-Dos in the current project',
  	category = map.CATEGORY.VIEW,
  	mode = map.MODE.NORMAL,
  	keys = map.KEY.LEADER .. map.KEY.P .. map.KEY.T,
  	command = function() 
			local root = project.determine_project_root({},'~')
			local cwd = ''
			if root then
				cwd = ' cwd=' .. root
			end
  		vim.cmd ('TodoTrouble' .. cwd)
		end,
  }
  map{
  	description = 'Search all To-Dos in the current project',
  	category = map.CATEGORY.VIEW,
  	mode = map.MODE.NORMAL,
  	keys = map.KEY.LEADER .. map.KEY.T .. map.KEY.T,
  	command = function() 
			local root = project.determine_project_root({},'~')
			local cwd = ''
			if root then
				cwd = ' cwd=' .. root
			end
  		vim.cmd ('TodoTelescope' .. cwd)
		end,
  }
end)
