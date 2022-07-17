-- TODO: once the colortheme is lushified, use it as a source of colors here
local want = require 'bugabinga.std.want'
want { 'nvim-web-devicons' } (function(devicons)
	devicons.setup {
		-- return a default icon when icon query cannot be mapped to existing icon
		default = true,
		override = {
			--
			-- FILE
			sh = { icon = '', color = '#1DC123', cterm_color = '59', name = 'Sh' },
			toml = { icon = '', color = '#e24329', cterm_color = '59', name = 'Toml' },
			justfile = { icon = 'ﮧ', color = '#999eff', cterm_color = '59', name = 'Justfile' },
			Justfile = { icon = 'ﮧ', color = '#999eff', cterm_color = '59', name = 'Justfile' },
			['.justfile'] = { icon = 'ﮧ', color = '#999eff', cterm_color = '59', name = 'Justfile' },
			['.Justfile'] = { icon = 'ﮧ', color = '#999eff', cterm_color = '59', name = 'Justfile' },
			['.gitattributes'] = { icon = '', color = '#e24329', cterm_color = '59', name = 'GitAttributes' },
			['.gitconfig'] = { icon = '', color = '#e24329', cterm_color = '59', name = 'GitConfig' },
			['.gitignore'] = { icon = '', color = '#e24329', cterm_color = '59', name = 'GitIgnore' },
			['.gitlab-ci.yml'] = { icon = '', color = '#e24329', cterm_color = '166', name = 'GitlabCI' },
			['.gitmodules'] = { icon = '', color = '#e24329', cterm_color = '59', name = 'GitModules' },
			['diff'] = { icon = '', color = '#e24329', cterm_color = '59', name = 'Diff' },
			--
			-- KIND
			Text = { icon = '', color = '#949494', cterm_color = '59', name = 'TextSymbol' },
			Method = { icon = 'm', color = '#949494', cterm_color = '59', name = 'MethodSymbol' },
			Function = { icon = '', color = '#949494', cterm_color = '59', name = 'FunctionSymbol' },
			Constructor = { icon = '', color = '#949494', cterm_color = '59', name = 'ConstructorSymbol' },
			Field = { icon = '', color = '#949494', cterm_color = '59', name = 'FieldSymbol' },
			Variable = { icon = '', color = '#949494', cterm_color = '59', name = 'VariableSymbol' },
			Class = { icon = '', color = '#949494', cterm_color = '59', name = 'ClassSymbol' },
			Interface = { icon = '', color = '#949494', cterm_color = '59', name = 'InterfaceSymbol' },
			Module = { icon = '', color = '#949494', cterm_color = '59', name = 'ModuleSymbol' },
			Property = { icon = '', color = '#949494', cterm_color = '59', name = 'PropertySymbol' },
			Unit = { icon = '', color = '#949494', cterm_color = '59', name = 'UnitSymbol' },
			Value = { icon = '', color = '#949494', cterm_color = '59', name = 'ValueSymbol' },
			Enum = { icon = '', color = '#949494', cterm_color = '59', name = 'EnumSymbol' },
			Keyword = { icon = '', color = '#949494', cterm_color = '59', name = 'KeywordSymbol' },
			Snippet = { icon = '', color = '#949494', cterm_color = '59', name = 'SnippetSymbol' },
			Color = { icon = '', color = '#949494', cterm_color = '59', name = 'ColorSymbol' },
			File = { icon = '', color = '#949494', cterm_color = '59', name = 'FileSymbol' },
			Reference = { icon = '', color = '#949494', cterm_color = '59', name = 'ReferenceSymbol' },
			Folder = { icon = '', color = '#949494', cterm_color = '59', name = 'FolderSymbol' },
			EnumMember = { icon = '', color = '#949494', cterm_color = '59', name = 'EnumMemberSymbol' },
			Constant = { icon = '', color = '#949494', cterm_color = '59', name = 'ConstantSymbol' },
			Struct = { icon = '', color = '#949494', cterm_color = '59', name = 'StructSymbol' },
			Event = { icon = '', color = '#949494', cterm_color = '59', name = 'EventSymbol' },
			Operator = { icon = '', color = '#949494', cterm_color = '59', name = 'OperatorSymbol' },
			TypeParameter = { icon = '', color = '#949494', cterm_color = '59', name = 'TypeParameterSymbol' },
			--
			-- TYPE
			Array = { icon = '', color = '#949494', cterm_color = '59', name = 'ArraySymbol' },
			Number = { icon = '', color = '#949494', cterm_color = '59', name = 'NumberSymbol' },
			String = { icon = '', color = '#949494', cterm_color = '59', name = 'StringSymbol' },
			Boolean = { icon = '蘒', color = '#949494', cterm_color = '59', name = 'BooleanSymbol' },
			Object = { icon = '', color = '#949494', cterm_color = '59', name = 'ObjectSymbol' },
			--
			-- DOCUMENTS
			Files = { icon = '', color = '#949494', cterm_color = '59', name = 'FilesSymbol' },
			OpenFolder = { icon = '', color = '#949494', cterm_color = '59', name = 'OpenFolderSymbol' },
			EmptyFolder = { icon = '', color = '#949494', cterm_color = '59', name = 'EmptyFolderSymbol' },
			--
			-- VCS
			VcsAdded = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsAddedSymbol' },
			VcsModified = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsModifiedSymbol' },
			VcsRemoved = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsRemovedSymbol' },
			VcsIgnored = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsIgnoredSymbol' },
			VcsRenamed = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsRenamedSymbol' },
			VcsDiff = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsDiffSymbol' },
			VcsRepo = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsRepoSymbol' },
			VcsUntracked = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsUntrackedSymbol' },
			VcsUnstaged = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsUnstagedSymbol' },
			VcsStaged = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsStagedSymbol' },
			VcsConflicted = { icon = '', color = '#949494', cterm_color = '59', name = 'VcsConflictedSymbol' },
			--
			--UI
			ArrowClosed = { icon = '', color = '#949494', cterm_color = '59', name = 'ArrowClosedSymbol' },
			ArrowOpen = { icon = '', color = '#949494', cterm_color = '59', name = 'ArrowOpenSymbol' },
			Lock = { icon = '', color = '#949494', cterm_color = '59', name = 'LockSymbol' },
			Circle = { icon = '', color = '#949494', cterm_color = '59', name = 'CircleSymbol' },
			BigCircle = { icon = '', color = '#949494', cterm_color = '59', name = 'BigCircleSymbol' },
			BigUnfilledCircle = { icon = '', color = '#949494', cterm_color = '59', name = 'BigUnfilledCircleSymbol' },
			Close = { icon = '', color = '#949494', cterm_color = '59', name = 'CloseSymbol' },
			NewFile = { icon = '', color = '#949494', cterm_color = '59', name = 'NewFileSymbol' },
			Search = { icon = '', color = '#949494', cterm_color = '59', name = 'SearchSymbol' },
			Lightbulb = { icon = '', color = '#949494', cterm_color = '59', name = 'LightbulbSymbol' },
			Project = { icon = '', color = '#949494', cterm_color = '59', name = 'ProjectSymbol' },
			Dashboard = { icon = '', color = '#949494', cterm_color = '59', name = 'DashboardSymbol' },
			History = { icon = '', color = '#949494', cterm_color = '59', name = 'HistorySymbol' },
			Comment = { icon = '', color = '#949494', cterm_color = '59', name = 'CommentSymbol' },
			Bug = { icon = '', color = '#949494', cterm_color = '59', name = 'BugSymbol' },
			Code = { icon = '', color = '#949494', cterm_color = '59', name = 'CodeSymbol' },
			Telescope = { icon = '', color = '#949494', cterm_color = '59', name = 'TelescopeSymbol' },
			Gear = { icon = '', color = '#949494', cterm_color = '59', name = 'GearSymbol' },
			Package = { icon = '', color = '#949494', cterm_color = '59', name = 'PackageSymbol' },
			List = { icon = '', color = '#949494', cterm_color = '59', name = 'ListSymbol' },
			SignIn = { icon = '', color = '#949494', cterm_color = '59', name = 'SignInSymbol' },
			SignOut = { icon = '', color = '#949494', cterm_color = '59', name = 'SignOutSymbol' },
			Check = { icon = '', color = '#949494', cterm_color = '59', name = 'CheckSymbol' },
			Fire = { icon = '', color = '#949494', cterm_color = '59', name = 'FireSymbol' },
			Note = { icon = '', color = '#949494', cterm_color = '59', name = 'NoteSymbol' },
			BookMark = { icon = '', color = '#949494', cterm_color = '59', name = 'BookMarkSymbol' },
			Pencil = { icon = '', color = '#949494', cterm_color = '59', name = 'PencilSymbol' },
			ChevronRight = { icon = '', color = '#949494', cterm_color = '59', name = 'ChevronRightSymbol' },
			Table = { icon = '', color = '#949494', cterm_color = '59', name = 'TableSymbol' },
			Calendar = { icon = '', color = '#949494', cterm_color = '59', name = 'CalendarSymbol' },
			CloudDownload = { icon = '', color = '#949494', cterm_color = '59', name = 'CloudDownloadSymbol' },
			--
			-- DIAGNOSTICS
			Error = { icon = '', color = '#949494', cterm_color = '59', name = 'ErrorSymbol' },
			Warning = { icon = '', color = '#949494', cterm_color = '59', name = 'WarningSymbol' },
			Information = { icon = '', color = '#949494', cterm_color = '59', name = 'InformationSymbol' },
			Question = { icon = '', color = '#949494', cterm_color = '59', name = 'QuestionSymbol' },
			Hint = { icon = '', color = '#949494', cterm_color = '59', name = 'HintSymbol' },
			--
			-- MISCELLANEOUS
			Robot = { icon = 'ﮧ', color = '#949494', cterm_color = '59', name = 'RobotSymbol' },
			Squirrel = { icon = '', color = '#949494', cterm_color = '59', name = 'SquirrelSymbol' },
			Tag = { icon = '', color = '#949494', cterm_color = '59', name = 'TagSymbol' },
			Watch = { icon = '', color = '#949494', cterm_color = '59', name = 'WatchSymbol' },
		},
	}
	-- devicons will return some default icon, when an icon name could not be mapped.
	-- in order to quickly notice these cases and debug them, set a noticeable icon as default.
	devicons.set_default_icon('ﴫ', '#ff00ff')
end)
