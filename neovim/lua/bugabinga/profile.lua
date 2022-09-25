local plenary_profile_ok, plenary_profile = pcall(require, 'plenary.profile')
local profile_file = 'profile.log'

-- return a profiler facade, that delegates to plenary.profile if it exists.
-- also, if vim.g.profile_mode is false, these methods to nothing.
return {
	start = function()
		if plenary_profile_ok and vim.g.profile_mode then
			plenary_profile.start(profile_file, {flame = true})
		elseif not plenary_profile_ok then
			vim.notify'profiler could not be loaded'
		end
	end,
	stop = function()
		if plenary_profile_ok and vim.g.profile_mode then
			plenary_profile.stop()
			convert_to_svg(profile_file)
			if vim.fn.executable"inferno-flamegraph" then
				vim.fn.system("inferno-flamegraph " .. profile_file .. " | save profile.svg")
			end
		end
	end,
}
