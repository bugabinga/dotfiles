return function(autocommand)
	-- YAML is very whitespace-sensite
	autocommand { yaml_settings = [[ FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 ]] }
end
