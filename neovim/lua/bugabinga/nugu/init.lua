local palette = require'bugabinga.nugu.palette'
local lush = require 'lush'
local hsl = lush.hsluv

local flux = function(color, number)
  if vim.opt.background:get() == 'dark' then
    return color.li(-number)
  else
    return color.li(number)
  end
end

local debug = hsl ( palette.debug )
local error = hsl ( palette.error )
local info = hsl ( palette.info )
local warning = hsl ( palette.warning )

local content_normal = hsl ( palette.content_normal )
local content_backdrop = hsl ( palette.content_backdrop )
local content_accent = hsl ( palette.content_accent )
local content_minor = hsl ( palette.content_minor )
local content_focus = hsl ( palette.content_focus )
local content_unfocus = hsl ( palette.content_unfocus )
local content_important_global = hsl ( palette.content_important_global )
local content_important_local = hsl ( palette.content_important_local )

local ui_normal = hsl ( palette.ui_normal )
local ui_backdrop = hsl ( palette.ui_backdrop )
local ui_accent = hsl ( palette.ui_accent )
local ui_minor = hsl ( palette.ui_minor )
local ui_focus = hsl ( palette.ui_focus )
local ui_unfocus = hsl ( palette.ui_unfocus )
local ui_important_global = hsl ( palette.ui_important_global )
local ui_important_local = hsl ( palette.ui_important_local )

local nugu = lush(function(injects)
  local sym = injects.sym
  return {
    Debug { fg = debug.readable(), bg = debug, gui = 'bold' }, --    debugging statements

    Normal { fg = content_normal, bg = content_backdrop },
    NotifyBackground { bg = ui_backdrop },
    Comment { fg = content_important_global, gui = 'bold italic' },
    LineNr { fg = ui_minor, bg = ui_backdrop },
    CursorLineNr { fg = ui_focus, bg = ui_backdrop },
    Search { fg = content_important_global.readable(), bg = content_important_global },
    IncSearch { fg = content_important_local.readable(), bg = content_important_local },

    NormalFloat { fg = ui_normal, bg = ui_backdrop }, -- Normal text in floating windows.
    FloatBorder { fg = ui_accent, bg = NormalFloat.bg },
    ColorColumn { fg = ui_important_global, bg = content_backdrop }, -- used for the columns set with 'colorcolumn'
    Conceal { fg = content_normal, bg = ui_unfocus, gui = 'italic' }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor { bg = ui_accent }, -- character under the cursor
    lCursor { bg = ui_accent }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    CursorIM { bg = ui_accent }, -- like Cursor, but used when in IME mode |CursorIM|
    Directory { fg = Normal.fg }, -- directory names (and other special names in listings)
    DiffAdd { fg = content_focus }, -- diff mode: Added line |diff.txt|
    DiffDelete { fg = content_focus, gui = "strikethrough" }, -- diff mode: Deleted line |diff.txt|
    DiffChange { fg = content_important_global }, -- diff mode: Changed line |diff.txt|
    DiffText { fg = content_important_local.readable(), bg = content_important_local }, -- diff mode: Changed text within a changed line |diff.txt|
    EndOfBuffer { LineNr }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    TermCursor { lCursor }, -- cursor in a focused terminal
    TermCursorNC { Cursor }, -- cursor in an unfocused terminal
    ErrorMsg { fg = error.readable(), bg = error }, -- error messages on the command line
    VertSplit { fg = ui_important_global, bg = content_backdrop }, -- the column separating vertically split windows
    Folded { Conceal }, -- line used for closed folds
    FoldColumn { Conceal }, -- 'foldcolumn'
    SignColumn { bg = ui_backdrop }, -- column where |signs| are displayed
    ModeMsg { gui = 'bold' }, -- 'showmode' message (e.g., "-- INSERT -- ")
    MsgArea { Normal }, -- Area for messages and cmdline
    MsgSeparator { fg = ui_accent }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    MoreMsg { Normal }, -- |more-prompt|
    NonText { fg = ui_unfocus }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    NormalNC {}, -- normal text in non-current windows
    Pmenu { NormalFloat }, -- Popup menu: normal item.
    PmenuSel { fg = ui_focus.readable(), sp = ui_focus.readable(), bg = ui_focus, gui = 'underline' }, -- Popup menu: selected item.
    PmenuSbar { bg = ui_unfocus }, -- Popup menu: scrollbar.
    PmenuThumb { bg = ui_minor }, -- Popup menu: Thumb of the scrollbar.
    Question { fg = ui_important_global, gui = 'bold' }, -- |hit-enter| prompt and yes/no questions
    QuickFixLine { PmenuSel }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    SpecialKey { fg = error, bg = content_unfocus, gui = 'bold' }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    SpellBad { fg = error, gui = 'undercurl' }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    SpellCap { SpellBad }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    SpellLocal { SpellBad }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    SpellRare { SpellBad }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    StatusLine { fg = ui_normal, bg = ui_backdrop }, -- status line of current window
    StatusLineNC { fg = ui_normal, bg = ui_unfocus }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    Winbar { StatusLine },
    WinbarNC { StatusLineNC },
    IndentBlanklineContextChar{ fg = content_accent, gui = "nocombine" },
    IndentBlanklineContextStart { sp = IndentBlanklineContextChar.fg, gui = "underline" },
    Title { fg = content_important_global, sp = content_important_global, gui = 'bold underline' }, -- titles for output from ":set all", ":autocmd" etc.
    TabLine { StatusLine }, -- tab pages line, not active tab page label
    TabLineFill { bg = TabLine.bg }, -- tab pages line, where there are no labels
    TabLineSel { fg = ui_accent.readable(), bg = ui_accent, gui = 'underline bold' }, -- tab pages line, active tab page label
    Visual { fg = content_focus.readable(), bg = content_focus }, -- Visual mode selection
    VisualNOS { fg = Visual.fg, bg = flux(Visual.bg, -42) }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg { fg = warning, gui = 'bold' }, -- warning messages
    WhiteSpace { fg = ui_unfocus }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    WildMenu { fg = ui_accent, gui = 'bold' }, -- current match in 'wildmenu' completion

		String { fg = content_important_local, gui = 'italic' },
    Constant { String }, -- (preferred) any constant
    Character { String }, --  a character constant: 'c', '\n'
    Number { String }, --   a number constant: 234, 0xff
    Boolean { String }, --  a boolean constant: TRUE, false
    Float { String }, --    a floating point constant: 2.3e10

    Identifier { Normal }, -- (preferred) any variable name
    Function { Normal }, -- function name (also: methods for classes)

    Statement { fg = content_minor }, -- (preferred) any statement
    Conditional { Statement }, --  if, then, else, endif, switch, etc.
    Repeat { Statement }, --   for, do, while, etc.
    Label { Statement }, --    case, default, etc.
    Operator { Statement }, -- "sizeof", "+", "*", etc.
    Keyword { Statement }, --  any other keyword
    Exception { Statement }, --  try, catch, throw

    PreProc { fg = content_important_global, bg = content_unfocus, gui = 'bold' }, -- (preferred) generic Preprocessor
    Include { PreProc }, --  preprocessor #include
    Define { PreProc }, --   preprocessor #define
    Macro { PreProc }, --    same as Define
    PreCondit { PreProc }, --  preprocessor #if, #else, #endif, etc.

    Type { Statement }, -- (preferred) int, long, char, etc.
    StorageClass { Statement }, -- static, register, volatile, etc.
    Structure { Statement }, --  struct, union, enum, etc.
    Typedef { Statement }, --  A typedef

    Special { fg = content_normal, gui = 'italic bold' }, -- (preferred) any special symbol
    SpecialChar { Special }, --  special character in a constant
    Tag { Special }, --    you can use CTRL-] on this
    Delimiter { fg = content_minor }, --  character that needs attention
    SpecialComment { Special }, -- special things inside a comment

    Underlined { sp = content_normal, gui = 'underline' }, -- (preferred) text that stands out, HTML links
    Bold { gui = 'bold' },
    Italic { gui = 'italic' },

    -- ("Ignore", below, may be invisible...)
    Ignore         { fg = Normal.bg, bg = Normal.bg }, -- (preferred) left blank, hidden  |hl-Ignore|

    Error { fg = error }, -- (preferred) any erroneous construct

    Todo { fg = content_important_global, sp = content_important_global, gui = 'bold underdouble' },

    DiagnosticUnnecessary { fg = ui_focus },
    DiagnosticDeprecated { fg = ui_important_global, sp = ui_important_global, gui = 'strikethrough' },

    DiagnosticError { fg = error },
    DiagnosticWarn { fg = warning },
    DiagnosticInfo { fg = info },
    DiagnosticHint { fg = ui_important_local },
    DiagnosticOk { fg = ui_minor },

    DiagnosticVirtualTextError { DiagnosticError },
    DiagnosticVirtualTextWarn { DiagnosticWarn },
    DiagnosticVirtualTextInfo { DiagnosticInfo },
    DiagnosticVirtualTextHint { DiagnosticHint },
    DiagnosticVirtualOkHint { DiagnosticOk },

    DiagnosticUnderlineError { fg = DiagnosticError.fg, sp = DiagnosticError.fg, gui = 'underdouble' },
    DiagnosticUnderlineWarn { fg = DiagnosticWarn.fg, sp = DiagnosticWarn.fg, gui = 'underline' },
    DiagnosticUnderlineInfo { fg = DiagnosticInfo.fg, sp = DiagnosticInfo.fg, gui = 'underdashed' },
    DiagnosticUnderlineHint { fg = DiagnosticHint.fg, sp = DiagnosticHint.fg, gui = 'italic underdotted' },
    DiagnosticUnderlineOk { fg = DiagnosticOk.fg, gui = 'italic' },

    DiagnosticSignError { DiagnosticError },
    DiagnosticSignWarn { DiagnosticWarn },
    DiagnosticSignInfo { DiagnosticInfo },
    DiagnosticSignHint { DiagnosticHint },
    DiagnosticSignOk { DiagnosticOk },

    LspReferenceText { Search },
    LspReferenceRead { Search },
    LspReferenceWrite { IncSearch },

		-- hlargs.nvim 
		Hlargs { fg = ui_important_local, gui = 'bold underdotted' },

    -- Tree-Sitter syntax groups.
    --
    -- See :h treesitter-highlight-groups, some groups may not be listed,
    -- submit a PR fix to lush-template!
    --
    -- Tree-Sitter groups are defined with an "@" symbol, which must be
    -- specially handled to be valid lua code, we do this via the special
    -- sym function. The following are all valid ways to call the sym function,
    -- for more details see https://www.lua.org/pil/5.html
    --
    -- sym("@text.literal")
    -- sym('@text.literal')
    -- sym"@text.literal"
    -- sym'@text.literal'
    --
    -- For more information see https://github.com/rktjmp/lush.nvim/issues/109

    -- sym"@text.literal"      { }, -- Comment
    -- sym"@text.reference"    { }, -- Identifier
    -- sym"@text.title"        { }, -- Title
    -- sym"@text.uri"          { }, -- Underlined
    -- sym"@text.underline"    { }, -- Underlined
    -- sym"@text.todo"         { }, -- Todo
    -- sym"@comment"           { }, -- Comment
    -- sym"@punctuation"       { }, -- Delimiter
    -- sym"@constant"          { }, -- Constant
    -- sym"@constant.builtin"  { }, -- Special
    -- sym"@constant.macro"    { }, -- Define
    -- sym"@define"            { }, -- Define
    -- sym"@macro"             { }, -- Macro
    -- sym"@string"            { }, -- String
    -- sym"@string.escape"     { }, -- SpecialChar
    -- sym"@string.special"    { }, -- SpecialChar
    -- sym"@character"         { }, -- Character
    -- sym"@character.special" { }, -- SpecialChar
    -- sym"@number"            { }, -- Number
    -- sym"@boolean"           { }, -- Boolean
    -- sym"@float"             { }, -- Float
    -- sym"@function"          { }, -- Function
    -- sym"@function.builtin"  { }, -- Special
    -- sym"@function.macro"    { }, -- Macro
    -- sym"@parameter"         { }, -- Identifier
    -- sym"@method"            { }, -- Function
    -- sym"@field"             { }, -- Identifier
    -- sym"@property"          { }, -- Identifier
    -- sym"@constructor"       { }, -- Special
    -- sym"@conditional"       { }, -- Conditional
    -- sym"@repeat"            { }, -- Repeat
    -- sym"@label"             { }, -- Label
    -- sym"@operator"          { }, -- Operator
    -- sym"@keyword"           { }, -- Keyword
    -- sym"@exception"         { }, -- Exception
    -- sym"@variable"          { }, -- Identifier
    -- sym"@type"              { }, -- Type
    -- sym"@type.definition"   { }, -- Typedef
    -- sym"@storageclass"      { }, -- StorageClass
    -- sym"@structure"         { }, -- Structure
    -- sym"@namespace"         { }, -- Identifier
    -- sym"@include"           { }, -- Include
    -- sym"@preproc"           { }, -- PreProc
    -- sym"@debug"             { }, -- Debug
    -- sym"@tag"               { }, -- Tag

    -- lazy.nvim
    LazyButton { NormalFloat, sp = NormalFloat.fg, gui = 'bold' },
    LazyButtonActive { fg = ui_important_local.readable(), sp = NormalFloat.fg, bg = ui_important_local, gui = LazyButton.gui },
    LazyComment { Keyword },
    LazyCommit { LazyComment },
    LazyCommitIssue { LazyComment },
    LazyCommitScope { LazyComment, gui = 'italic' },
    LazyCommitType { LazyCommitScope },
    LazyDimmed { fg = NormalFloat.fg },
    LazyDir { N.fgormalFloat },
    LazyH1 { Bold },
    LazyH2 { LazyH1 },
    LazyLocal {},
    LazyNoCond { WarningMsg },
    LazyNormal { NormalFloat },
    LazyProgressDone { fg = Search.bg, bg = Cursor.bg, gui = 'bold' },
    LazyProgressTodo { fg = LazyProgressDone.bg, bg = LazyProgressDone.fg, gui = LazyProgressDone.gui },
    LazyProp { LazyComment },
    LazyReasonCmd { N.fgormalFloat },
    LazyReasonEvent { N.fgormalFloat },
    LazyReasonFt { N.fgormalFloat },
    LazyReasonImport { N.fgormalFloat },
    LazyReasonKeys { N.fgormalFloat },
    LazyReasonPlugin { N.fgormalFloat },
    LazyReasonRuntime { N.fgormalFloat },
    LazyReasonSource { N.fgormalFloat },
    LazyReasonStart { N.fgormalFloat },
    LazySpecial { fg = ColorColumn.fg },
    LazyTaskError { ErrorMsg },
    LazyTaskOutput { Debug },
    LazyUrl { sp = NormalFloat.fg, gui = 'italic underline' },
    LazyValue { gui = 'italic' },

    -- Noice
    NoiceCmdline { fg = ui_focus, bg = ui_backdrop },

    NoiceCmdlineIcon { fg = ui_accent, bg = NoiceCmdline.bg, gui = 'bold' },
    NoiceCmdlineIconCalculator { NoiceCmdlineIcon },
    NoiceCmdlineIconCmdline { fg = ui_accent, bg = NoiceCmdlineIcon.bg, gui = NoiceCmdlineIcon.gui },
    NoiceCmdlineIconFilter { NoiceCmdlineIcon },
    NoiceCmdlineIconHelp { NoiceCmdlineIcon },
    NoiceCmdlineIconIncRename { NoiceCmdlineIcon },
    NoiceCmdlineIconInput { NoiceCmdlineIcon },
    NoiceCmdlineIconLua { NoiceCmdlineIcon },
    NoiceCmdlineIconSearch { NoiceCmdlineIcon },

    NoiceCmdlinePopup { NormalFloat },
    NoiceCmdlinePopupBorder { NoiceCmdlinePopup },
    NoiceCmdlinePopupBorderCalculator { NoiceCmdlinePopup },
    NoiceCmdlinePopupBorderCmdline { NoiceCmdlinePopup },
    NoiceCmdlinePopupBorderFilter { NoiceCmdlinePopup },
    NoiceCmdlinePopupBorderHelp { NoiceCmdlinePopup },
    NoiceCmdlinePopupBorderIncRename { NoiceCmdlinePopup },
    NoiceCmdlinePopupBorderInput { NoiceCmdlinePopup },
    NoiceCmdlinePopupBorderLua { NoiceCmdlinePopup },
    NoiceCmdlinePopupBorderSearch { NoiceCmdlinePopup },
    NoiceCmdlinePopupTitle { NoiceCmdlinePopup },

    NoiceCmdlinePrompt { fg = ui_important_global, bg = ui_backdrop, gui = 'bold' },

    NoiceCompletionItemKindDefault { fg = ui_normal },
    NoiceCompletionItemKindClass { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindColor { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindConstant { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindConstructor { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindEnum { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindEnumMember { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindField { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindFile { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindFolder { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindFunction { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindInterface { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindKeyword { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindMethod { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindModule { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindProperty { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindSnippet { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindStruct { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindText { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindUnit { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindValue { NoiceCompletionItemKindDefault },
    NoiceCompletionItemKindVariable { NoiceCompletionItemKindDefault },
    NoiceCompletionItemMenu { NoiceCompletionItemKindDefault },
    NoiceCompletionItemWord { NoiceCompletionItemKindDefault },

    NoiceConfirm { NormalFloat },
    NoiceConfirmBorder { fg = ui_accent, bg = NormalFloat.bg },
    NoiceFormatConfirm { LazyButton },
    NoiceFormatConfirmDefault { LazyButtonActive },

    NoiceCursor { Cursor },

    NoiceFormatDate { NonText },
    NoiceFormatEvent { NonText },
    NoiceFormatKind { NonText },
    NoiceFormatLevelDebug { fg = Debug.bg },
    NoiceFormatLevelError { DiagnosticError },
    NoiceFormatLevelInfo { DiagnosticInfo },
    NoiceFormatLevelOff { fg = content_minor },
    NoiceFormatLevelTrace { DiagnosticHint },
    NoiceFormatLevelWarn { DiagnosticWarn },
    NoiceFormatProgressDone { LazyProgressDone },
    NoiceFormatProgressTodo { LazyProgressTodo },
    NoiceFormatTitle { Title },

    NoiceLspProgressClient { Debug },
    NoiceLspProgressSpinner { Debug },
    NoiceLspProgressTitle { Debug },

    NoiceMini { DiagnosticInfo },

    NoicePopup { NormalFloat },
    NoicePopupBorder { fg = ui_accent, bg = NormalFloat.bg },

    NoicePopupmenu { Pmenu },
    NoicePopupmenuBorder { fg = ui_accent , bg = NormalFloat.bg },
    NoicePopupmenuMatch { Bold },
    NoicePopupmenuSelected { PmenuSel },

    NoiceScrollbar { PmenuSbar },
    NoiceScrollbarThumb { PmenuThumb },

    NoiceSplit { NormalFloat },
    NoiceSplitBorder { NoiceConfirmBorder , bg = NormalFloat.bg},

    NoiceVirtualText { fg = ui_important_local, bg = ui_backdrop, gui = 'bold' },

    -- Notify
    NotifyERRORBorder { DiagnosticError , bg = NormalFloat.bg },
    NotifyWARNBorder { DiagnosticWarn, bg = NormalFloat.bg  },
    NotifyINFOBorder { DiagnosticInfo, bg = NormalFloat.bg },
    NotifyDEBUGBorder { fg = Debug.bg, bg = NormalFloat.bg  },
    NotifyTRACEBorder { DiagnosticHint, bg = NormalFloat.bg  },

    NotifyERRORIcon { NotifyERRORBorder },
    NotifyWARNIcon { NotifyWARNBorder },
    NotifyINFOIcon { NotifyINFOBorder },
    NotifyDEBUGIcon { NotifyDEBUGBorder },
    NotifyTRACEIcon { NotifyTRACEBorder },

    NotifyERRORTitle { NotifyERRORBorder },
    NotifyWARNTitle { NotifyWARNBorder },
    NotifyINFOTitle { NotifyINFOBorder },
    NotifyDEBUGTitle { NotifyDEBUGBorder },
    NotifyTRACETitle { NotifyTRACEBorder },

    NotifyERRORBody { NormalFloat },
    NotifyWARNBody { NormalFloat },
    NotifyINFOBody { NormalFloat },
    NotifyDEBUGBody { NormalFloat },
    NotifyTRACEBody { NormalFloat },


		TelescopeSelectionCaret { PmenuSel },
		TelescopeSelection { PmenuSel },
		TelescopeMultiSelection { fg = PmenuSel.fg, bg = ui_important_local },

    GitSignsAdd{fg = DiffAdd.fg, bg = ui_backdrop },
    GitSignsChange{ fg = DiffChange.fg, bg = ui_backdrop },
    GitSignsDelete{ fg = DiffDelete.fg, bg = ui_backdrop },

    GitSignsChangedelete{ GitSignsChange },
    GitSignsTopdelete{ GitSignsDelete },
    GitSignsUntracked{ GitSignsAdd },

    GitSignsAddNr{ GitSignsAdd },
    GitSignsChangeNr{ GitSignsChange },
    GitSignsDeleteNr{ GitSignsDelete },

    GitSignsChangedeleteNr{ GitSignsChange },
    GitSignsTopdeleteNr{ GitSignsDelete },
    GitSignsUntrackedNr{ GitSignsAdd },

    GitSignsAddLn{ GitSignsAdd },
    GitSignsChangeLn{ GitSignsChange },
    GitSignsChangedeleteLn{ GitSignsChange },
    GitSignsUntrackedLn{ GitSignsAdd },

    GitSignsAddPreview{ GitSignsAdd },
    GitSignsDeletePreview{ GitSignsDelete },

    GitSignsCurrentLineBlame{ Debug },

    GitSignsAddInline{ GitSignsAdd },
    GitSignsDeleteInline{ GitSignsDelete },
    GitSignsChangeInline{ GitSignsChange },

    GitSignsAddLnInline{ DiffText },
    GitSignsDeleteLnInline{ DiffText },
    GitSignsChangeLnInline{ DiffText },

    GitSignsDeleteVirtLn{ GitSignsDelete },
    GitSignsDeleteVirtLnInLine{ DiffText },
    GitSignsVirtLnum{ fg = LineNr.fg },
  }
end)

return nugu
