return function(Group, groups, colors, styles)
  -- SYNTAX
  Group.new('Normal', colors.normal, colors.none, styles.NONE)
  Group.new('NormalNC', colors.minor, colors.none, styles.NONE)
  Group.new('NormalFloat', colors.important, colors.none, styles.NONE)

  Group.new(
    'Comment',
    colors.important,
    colors.none,
    styles.bold + styles.italic
  )

  Group.new('Constant', colors.debug, colors.none, styles.NONE)
  Group.new('String', colors.normal, colors.none, styles.bold + styles.italic)
  Group.new('Character', groups.String, groups.String, groups.String)
  Group.new('Number', groups.String, groups.String, groups.String)
  Group.new('Float', groups.String, groups.String, groups.String)
  Group.new('Boolean', groups.String, groups.String, groups.String)

  Group.new('Identifier', colors.normal, colors.none, styles.none)
  Group.new('Function', groups.Identifier, groups.Identifier, groups.Identifier)

  Group.new('Statement', colors.minor, colors.none, styles.italic)
  Group.new('Conditional', groups.Statement, groups.Statement, groups.Statement)
  Group.new('Repeat', groups.Statement, groups.Statement, groups.Statement)
  Group.new(
    'Label',
    groups.Statement,
    groups.Statement,
    groups.Statement + styles.underline
  )
  Group.new('Operator', groups.Statement, groups.Statement, groups.Statement)
  Group.new('Keyword', groups.Statement, groups.Statement, groups.Statement)
  Group.new('Exception', groups.Statement, groups.Statement, groups.Statement)

  Group.new('PreProc', groups.Statement, groups.Statement, groups.Statement)
  Group.new('Include', groups.PreProc, groups.PreProc, groups.PreProc)
  Group.new('Define', groups.PreProc, groups.PreProc, groups.PreProc)
  Group.new('Macro', groups.PreProc, groups.PreProc, groups.PreProc)
  Group.new('PreCondit', groups.PreProc, groups.PreProc, groups.PreProc)

  Group.new('Type', colors.normal, colors.none, styles.bold)
  Group.new(
    'StorageClass',
    groups.Statement,
    groups.Statement,
    groups.Statement
  )
  Group.new('Structure', groups.Statement, groups.Statement, groups.Statement)
  Group.new('Typedef', groups.Type, groups.Type, groups.Type)

  Group.new('Special', colors.minor, colors.none, styles.NONE)
  Group.new('SpecialKey', colors.normal, colors.none, styles.italic)
  Group.new('SpecialComment', colors.accent_strong, colors.none, styles.bold)
  Group.new('Tag', groups.Special, groups.Special, groups.Special)
  Group.new('Delimiter', groups.Special, groups.Special, groups.Special)
  Group.new('Debug', groups.Special, groups.Special, groups.Special)

  Group.new('Underlined', colors.accent_strong, colors.none, styles.underline)
  Group.new('Ignore', colors.debug, colors.none, styles.NONE)
  Group.new('Error', colors.error, colors.none, styles.bold + styles.underline)
  Group.new(
    'Todo',
    colors.accent_strong,
    colors.none,
    styles.bold + styles.underline
  )

  Group.new('Whitespace', colors.nonessential, colors.none, styles.NONE)
  Group.new('NonText', colors.debug, colors.none, styles.NONE)

  -- NVIM UI
  Group.new(
    'NvimInternalError',
    colors.error,
    colors.none,
    styles.bold + styles.underline
  )
  Group.new('ErrorMsg', colors.error, colors.none, styles.bold)
  Group.new('WarningMsg', colors.warning, colors.none, styles.bold)
  Group.new('MoreMsg', colors.information, colors.none, styles.NONE)
  Group.new('ModeMsg', colors.information, colors.none, styles.NONE)
  Group.new('Question', colors.information, colors.none, styles.bold)
  Group.new('MsgSeparator', colors.ui_minor, colors.none, styles.NONE)
  Group.new('MsgArea', colors.ui_normal, colors.none, styles.NONE)

  Group.new('EndOfBuffer', colors.nonessential, colors.none, styles.NONE)
  Group.new('LineNr', colors.nonessential, colors.none, styles.NONE)
  Group.new('CursorLineNr', colors.ui_normal, colors.none, styles.NONE)
  Group.new('CursorColumn', colors.none, colors.none, styles.inverse)
  Group.new('CursorLine', colors.none, colors.accent_weak, styles.NONE)
  Group.new('TermCursor', colors.none, colors.none, styles.inverse)
  Group.new('TermCursorNC', colors.none, colors.none, styles.NONE)
  Group.new('Cursor', colors.none, colors.none, styles.reverse)
  Group.new('lCursor', groups.Cursor, groups.Cursor, groups.Cursor)
  Group.new('ColorColumn', colors.none, colors.ui_normal, styles.NONE)
  Group.new('Visual', colors.accent_strong, colors.none, styles.NONE)
  Group.new('VisualNC', colors.accent_weak, colors.none, styles.NONE)
  Group.new('Conceal', colors.debug, colors.none, styles.NONE)
  Group.new('Substitute', colors.information, colors.none, styles.NONE)
  Group.new('MatchParen', colors.accent_strong, colors.none, styles.bold)

  Group.new('Directory', colors.normal, colors.none, styles.bold)
  Group.new(
    'Title',
    colors.ui_normal,
    colors.none,
    styles.bold + styles.underline
  )

  Group.new('IncSearch', colors.ui_important, colors.none, styles.underline)
  Group.new('Search', colors.important, colors.ui_important, styles.NONE)
  Group.new('VertSplit', colors.ui_normal, colors.none, styles.NONE)
  Group.new('WildMenu', colors.ui_normal, colors.none, styles.NONE)
  Group.new('Folded', colors.nonessential, colors.none, styles.NONE)
  Group.new('FoldColumn', colors.ui_normal, colors.none, styles.NONE)
  Group.new('SignColumn', colors.ui_normal, colors.none, styles.NONE)
  Group.new('StatusLine', colors.nonessential, colors.none, styles.NONE)
  Group.new('StatusLineNC', colors.none, colors.none, styles.NONE)
  Group.new('Pmenu', colors.ui_normal, colors.none, styles.NONE)
  Group.new('PmenuSel', colors.ui_important, colors.none, styles.underline)
  Group.new('PmenuSbar', colors.ui_minor, colors.none, styles.NONE)
  Group.new('PmenuThumb', colors.ui_important, colors.none, styles.NONE)
  Group.new('TabLine', colors.ui_normal, colors.none, styles.none)
  Group.new(
    'TabLineSel',
    colors.ui_important,
    colors.none,
    styles.bold + styles.underline
  )
  Group.new('TabLineFill', colors.ui_minor, colors.none, styles.NONE)
  Group.new('QuickFixLine', colors.ui_normal, colors.none, styles.NONE)

  Group.new('SpellBad', colors.warning, colors.none, styles.undercurl)
  Group.new('SpellCap', colors.debug, colors.none, styles.NONE)
  Group.new('SpellRare', colors.debug, colors.none, styles.NONE)
  Group.new('SpellLocal', colors.debug, colors.none, styles.NONE)

  Group.new('RedrawDebugNormal', colors.debug, colors.none, styles.NONE)
  Group.new('RedrawDebugClear', colors.debug, colors.none, styles.NONE)
  Group.new('RedrawDebugComposed', colors.debug, colors.none, styles.NONE)
  Group.new('RedrawDebugRecompose', colors.debug, colors.none, styles.NONE)
end
