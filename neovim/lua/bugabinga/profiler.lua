local ok, profiler = pcall(require, 'plenary.profile')
if not ok then
	return
end
--FIXME: fix file paths into stdpath data
local file = 'profile.log'
return {
	start = function()
		profiler.start(file, { flame = true })
	end,
	stop = function()
		profiler.stop()
		vim.fn.system('inferno-flamegraph ' .. file .. ' | save profile.svg')
	end,
}
