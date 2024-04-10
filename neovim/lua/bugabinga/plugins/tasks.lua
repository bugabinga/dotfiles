local map = require 'std.map'
local user_command = require 'std.user_command'

map.normal {
	description = 'Toggle task view',
	category = 'tasks',
	keys = '<leader>99',
	command = function () prequire 'overseer'.toggle { enter = true, direction = 'right', } end,
}

map.normal {
	description = 'Run task',
	category = 'tasks',
	keys = '<leader>9r',
	command = function () prequire 'overseer'._run_template() end,
}

map.normal {
	description = 'Run any command as task',
	category = 'tasks',
	keys = '<leader>9c',
	command = function () prequire 'overseer'._run_command() end,
}

map.normal {
	description = 'Load task bundle',
	category = 'tasks',
	keys = '<leader>9r',
	command = function () prequire 'overseer'._load_bundle() end,
}

map.normal {
	description = 'Run an action on the most recent task, or the task under the cursor',
	category = 'tasks',
	keys = '<leader>9d',
	command = function () prequire 'overseer'._quick_action() end,
}

map.normal {
	description = 'Select a task to run an action on',
	category = 'tasks',
	keys = '<leader>9s',
	command = function () prequire 'overseer'._task_action() end,
}

map.normal {
	description = 'Display diagnostic information about overseer',
	category = 'tasks',
	keys = '<leader>9i',
	command = function () prequire 'overseer'._info() end,
}

user_command.OverseerDebugParser
'Open a tab with windows laid out for debugging a parser' (
		function ()
			prequire 'overseer'.debug_parser()
		end
	)

user_command.Grep
'Run your grepprg as an Overseer task'
	{ nargs = '*', bang = true, bar = true, complete = 'file', } (
		function ( params )
			local args = vim.fn.expandcmd( params.args )
			-- Insert args at the '$*' in the grepprg
			local cmd, num_subs = vim.o.grepprg:gsub( '%$%*', args )
			if num_subs == 0 then
				cmd = cmd .. ' ' .. args
			end
			local cwd
			prequire( 'oil', function ( oil )
				cwd = oil.get_current_dir()
			end )
			local task = prequire 'overseer'.new_task {
				cmd = cmd,
				cwd = cwd,
				name = 'grep ' .. args,
				components = {
					{
						'on_output_quickfix',
						errorformat = vim.o.grepformat,
						open = not params.bang,
						open_height = 8,
						items_only = true,
					},
					-- We don't care to keep this around as long as most tasks
					{ 'on_complete_dispose', timeout = 30, },
					'default',
				},
			}
			task:start()
		end
	)

user_command.Make
'Run your makeprg as an Overseer task'
	{ nargs = '*', bang = true, } (
		function ( params )
			-- Insert args at the '$*' in the makeprg
			local cmd, num_subs = vim.o.makeprg:gsub( '%$%*', params.args )
			if num_subs == 0 then
				cmd = cmd .. ' ' .. params.args
			end
			local task = prequire 'overseer'.new_task {
				cmd = vim.fn.expandcmd( cmd ),
				components = {
					{ 'on_output_quickfix', open = not params.bang, open_height = 8, },
					'unique',
					'default',
				},
			}
			task:start()
		end
	)

return {
	{
		'stevearc/resession.nvim',
		lazy = true,
		opts = {
			extensions = {
				overseer = {
					status = { 'RUNNING', },
				},
			},
		},
	},
	{
		'stevearc/overseer.nvim',
		opts = {
			strategy = { 'jobstart', },
			dap = false,
			log = {
				{
					type = 'echo',
					level = vim.log.levels.WARN,
				},
				{
					type = 'file',
					filename = 'overseer.log',
					level = vim.log.levels.DEBUG,
				},
			},
			component_aliases = {
				default = {
					{
						'display_duration',
						detail_level = 2,
					},
					'on_output_summarize',
					'on_exit_set_status',
					{ 'on_complete_notify', system = 'unfocused', },
					'on_complete_dispose',
				},
				default_neotest = {
					'unique',
					{ 'on_complete_notify', system = 'unfocused', on_change = true, },
					'default',
				},
			},
		},
	}, }
