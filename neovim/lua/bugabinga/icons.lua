local want = require 'bugabinga.std.want'
want { 'nvim-web-devicons' }(function(devicons)
  devicons.setup {
    override = {
      sh = {
        icon = '',
        color = '#1DC123',
        cterm_color = '59',
        name = 'Sh',
      },
      toml = {
        icon = '',
        color = '#e24329',
        cterm_color = '59',
        name = 'Toml',
      },
      justfile = {
        icon = 'ﮧ',
        color = '#999eff',
        cterm_color = '59',
        name = 'Justfile',
      },
      Justfile = {
        icon = 'ﮧ',
        color = '#999eff',
        cterm_color = '59',
        name = 'Justfile',
      },
      ['.justfile'] = {
        icon = 'ﮧ',
        color = '#999eff',
        cterm_color = '59',
        name = 'Justfile',
      },
      ['.Justfile'] = {
        icon = 'ﮧ',
        color = '#999eff',
        cterm_color = '59',
        name = 'Justfile',
      },
      ['.gitattributes'] = {
        icon = '',
        color = '#e24329',
        cterm_color = '59',
        name = 'GitAttributes',
      },
      ['.gitconfig'] = {
        icon = '',
        color = '#e24329',
        cterm_color = '59',
        name = 'GitConfig',
      },
      ['.gitignore'] = {
        icon = '',
        color = '#e24329',
        cterm_color = '59',
        name = 'GitIgnore',
      },
      ['.gitlab-ci.yml'] = {
        icon = '',
        color = '#e24329',
        cterm_color = '166',
        name = 'GitlabCI',
      },
      ['.gitmodules'] = {
        icon = '',
        color = '#e24329',
        cterm_color = '59',
        name = 'GitModules',
      },
      ['diff'] = {
        icon = '',
        color = '#e24329',
        cterm_color = '59',
        name = 'Diff',
      },
    },
    default = true,
  }
end)

--[[ FIXME: integrate those into devicons
return {
	kind = {
		Text = "",
		Method = "m",
		Function = "",
		Constructor = "",
		Field = "",
		Variable = "",
		Class = "",
		Interface = "",
		Module = "",
		Property = "",
		Unit = "",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "",
		Event = "",
		Operator = "",
		TypeParameter = "",
	},
	type = {
		Array = "",
		Number = "",
		String = "",
		Boolean = "蘒",
		Object = "",
	},
	documents = {
		File = "",
		Files = "",
		Folder = "",
		OpenFolder = "",
	},
	git = {
		Add = "",
		Mod = "",
		Remove = "",
		Ignore = "",
		Rename = "",
		Diff = "",
		Repo = "",
	},
	ui = {
		ArrowClosed = "",
		ArrowOpen = "",
		Lock = "",
		Circle = "",
		BigCircle = "",
		BigUnfilledCircle = "",
		Close = "",
		NewFile = "",
		Search = "",
		Lightbulb = "",
		Project = "",
		Dashboard = "",
		History = "",
		Comment = "",
		Bug = "",
		Code = "",
		Telescope = "",
		Gear = "",
		Package = "",
		List = "",
		SignIn = "",
		SignOut = "",
		Check = "",
		Fire = "",
		Note = "",
		BookMark = "",
		Pencil = "",
		ChevronRight = "",
		Table = "",
		Calendar = "",
		CloudDownload = "",
	},
	diagnostics = {
		Error = "",
		Warning = "",
		Information = "",
		Question = "",
		Hint = "",
	},
	misc = {
		Robot = "ﮧ",
		Squirrel = "",
		Tag = "",
		Watch = "",
	},
}
]]
--