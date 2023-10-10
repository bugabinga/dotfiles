---@diagnostic disable: undefined-global
local palette = require 'bugabinga.nugu.palette'
local lush = require 'lush'
local hsl = lush.hsluv

vim.g.terminal_color_0 = palette.ui_backdrop              -- black
vim.g.terminal_color_1 = palette.content_accent           -- maroon
vim.g.terminal_color_2 = palette.info                     -- green
vim.g.terminal_color_3 = palette.ui_focus                 -- olive
vim.g.terminal_color_4 = palette.content_important_local  -- navy
vim.g.terminal_color_5 = palette.content_important_global -- purple
vim.g.terminal_color_6 = palette.ui_focus                 -- teal
vim.g.terminal_color_7 = palette.content_normal           -- silver

vim.g.terminal_color_8 = palette.ui_minor                 -- grey
vim.g.terminal_color_9 = palette.error                    -- red
vim.g.terminal_color_10 = palette.info                    -- lime
vim.g.terminal_color_11 = palette.content_focus           -- yellow
vim.g.terminal_color_12 = palette.ui_important_local      -- blue
vim.g.terminal_color_13 = palette.ui_accent               -- fuchsia
vim.g.terminal_color_14 = palette.ui_important_global     -- aqua
vim.g.terminal_color_15 = palette.ui_normal               -- white

local flux = function ( color, number )
  if vim.opt.background:get() == 'dark' then
    return color.li( -number )
  else
    return color.li( number )
  end
end

local debug = hsl( palette.debug )
local error = hsl( palette.error )
local info = hsl( palette.info )
local warning = hsl( palette.warning )

local content_normal = hsl( palette.content_normal )
local content_backdrop = hsl( palette.content_backdrop )
local content_accent = hsl( palette.content_accent )
local content_minor = hsl( palette.content_minor )
local content_focus = hsl( palette.content_focus )
local content_unfocus = hsl( palette.content_unfocus )
local content_important_global = hsl( palette.content_important_global )
local content_important_local = hsl( palette.content_important_local )

local ui_normal = hsl( palette.ui_normal )
local ui_backdrop = hsl( palette.ui_backdrop )
local ui_accent = hsl( palette.ui_accent )
local ui_minor = hsl( palette.ui_minor )
local ui_focus = hsl( palette.ui_focus )
local ui_unfocus = hsl( palette.ui_unfocus )
local ui_important_global = hsl( palette.ui_important_global )
local ui_important_local = hsl( palette.ui_important_local )

local nugu = lush( function ( injects )
  local sym = injects.sym
  return {
    Debug { fg = debug.readable(), bg = debug, gui = 'bold' },

    Normal { fg = content_normal, bg = content_backdrop },
    NotifyBackground { bg = ui_backdrop },
    Comment { fg = content_important_global, gui = 'bold italic' },
    LineNr { fg = ui_minor, bg = ui_backdrop },
    CursorLineNr { fg = ui_focus, bg = ui_backdrop },
    Search { fg = content_important_global.readable(), bg = content_important_global },
    IncSearch { fg = content_important_local.readable(), bg = content_important_local },
    NormalFloat { fg = ui_normal, bg = ui_backdrop },
    FloatBorder { fg = ui_accent, bg = NormalFloat.bg },
    ColorColumn { fg = ui_important_global, bg = content_backdrop },
    Conceal { fg = content_normal, bg = ui_unfocus, gui = 'italic' },
    Cursor { bg = ui_accent },
    lCursor { bg = ui_accent },
    CursorIM { bg = ui_accent },
    Directory { fg = Normal.fg },
    DiffAdd { fg = content_focus },
    DiffDelete { fg = content_focus, gui = 'strikethrough' },
    DiffChange { fg = content_important_global },
    DiffText { fg = content_important_local.readable(), bg = content_important_local },
    EndOfBuffer { NormalFloat },
    TermCursor { lCursor },
    TermCursorNC { Cursor },
    ErrorMsg { fg = error.readable(), bg = error },
    VertSplit { fg = ui_important_global, bg = ui_backdrop },
    Folded { Conceal },
    FoldColumn { LineNr },
    SignColumn { LineNr },
    ModeMsg { gui = 'bold' },
    MsgArea { Normal },
    MsgSeparator { fg = ui_accent },
    MoreMsg { Normal },
    NonText { fg = content_unfocus },
    Whitespace { NonText },
    NormalNC {},
    Pmenu { NormalFloat },
    PmenuSel { fg = ui_focus, sp = ui_focus.readable(), bg = ui_unfocus, gui = 'underline' },
    PmenuSbar { bg = ui_unfocus },
    PmenuThumb { bg = ui_minor },
    Question { fg = ui_important_global, gui = 'bold' },
    QuickFixLine { PmenuSel },
    SpecialKey { fg = error, bg = content_unfocus, gui = 'bold' },
    SpellBad { fg = error, gui = 'undercurl' },
    SpellCap { SpellBad },
    SpellLocal { SpellBad },
    SpellRare { SpellBad },
    StatusLine { fg = ui_normal, bg = ui_backdrop },
    StatusLineNC { fg = ui_minor, bg = ui_backdrop },
    Winbar { StatusLine },
    WinbarNC { StatusLineNC },
    Title { fg = content_important_global, sp = content_important_global, gui = 'bold underline' },
    TabLine { StatusLine },
    TabLineFill { bg = TabLine.bg },
    TabLineSel { fg = ui_accent.readable(), bg = ui_accent, gui = 'underline bold' },
    Visual { fg = content_focus.readable(), bg = content_focus },
    VisualNOS { fg = Visual.fg, bg = flux( Visual.bg, -42 ) },
    WarningMsg { fg = warning, gui = 'bold' },
    WhiteSpace { fg = ui_unfocus },
    WildMenu { fg = ui_accent, gui = 'bold' },

    String { fg = content_important_local, gui = 'italic' },
    Constant { String },
    Character { String },
    Number { String },
    Boolean { String },
    Float { String },

    Identifier { Normal },
    MutableVariable { Debug },
    Function { Normal },

    Statement { fg = content_minor },
    Conditional { Statement },
    Repeat { Statement },
    Label { Statement },
    Operator { Statement },
    Keyword { Statement },
    Exception { Statement },

    PreProc { fg = content_important_global, bg = content_unfocus, gui = 'bold' },
    Include { PreProc },
    Define { PreProc },
    Macro { PreProc },
    PreCondit { PreProc },

    Type { Statement },
    StorageClass { Statement },
    Structure { Statement },
    Typedef { Statement },

    Special { fg = content_normal, gui = 'italic bold' },
    SpecialChar { Special },
    Tag { Special },
    Delimiter { fg = content_minor },
    SpecialComment { Special },

    Underlined { sp = content_normal, gui = 'underline' },
    Bold { gui = 'bold' },
    Italic { gui = 'italic' },

    Ignore { fg = Normal.bg, bg = Normal.bg },

    Error { fg = error },
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

    LspReferenceText { sp = content_unfocus, gui = 'underline' },
    LspReferenceRead { LspReferenceText },
    LspReferenceWrite { LspReferenceText },
    LspInlayHint { fg = content_minor, bg = content_backdrop },

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

    sym '@text.literal' { Comment },
    sym '@text.reference' { Identifier },
    sym '@text.title' { Title },
    sym '@text.underline' { Underlined },
    sym '@text.todo' { Todo },
    sym '@comment' { Comment },
    sym '@punctuation' { Delimiter },
    sym '@constant' { Constant },
    sym '@constant.builtin' { Special },
    sym '@constant.macro' { Define },
    sym '@define' { Define },
    sym '@macro' { Macro },
    sym '@string' { String },
    sym '@string.escape' { SpecialChar },
    sym '@string.special' { SpecialChar },
    sym '@character' { Character },
    sym '@character.special' { SpecialChar },
    sym '@number' { Number },
    sym '@boolean' { Boolean },
    sym '@float' { Float },
    sym '@function' { Function },
    sym '@function.builtin' { Special },
    sym '@function.macro' { Macro },
    sym '@parameter' { Identifier },
    sym '@method' { Function },
    sym '@field' { Identifier },
    sym '@property' { Identifier },
    sym '@constructor' { Special },
    sym '@conditional' { Conditional },
    sym '@repeat' { Repeat },
    sym '@label' { Label },
    sym '@operator' { Operator },
    sym '@keyword' { Keyword },
    sym '@keyword.return' { fg = Keyword.fg, bg = Keyword.bg, gui = 'underline bold' },
    sym '@exception' { Exception },
    sym '@variable' { Identifier },
    sym '@type' { Type },
    sym '@type.definition' { Typedef },
    sym '@storageclass' { StorageClass },
    sym '@structure' { Structure },
    sym '@namespace' { Identifier },
    sym '@include' { Include },
    sym '@preproc' { PreProc },
    sym '@debug' { Debug },
    sym '@tag' { Tag },

    sym '@lsp.type.namespace' { sym '@namespace' },
    sym '@lsp.type.type' { sym '@type' },
    sym '@lsp.type.class' { sym '@type' },
    sym '@lsp.type.enum' { sym '@type' },
    sym '@lsp.type.interface' { sym '@type' },
    sym '@lsp.type.struct' { sym '@structure' },
    sym '@lsp.type.parameter' { sym '@parameter' },
    sym '@lsp.type.variable' { sym '@variable' },
    sym '@lsp.type.property' { sym '@property' },
    sym '@lsp.type.enumMember' { sym '@constant' },
    sym '@lsp.type.function' { sym '@function' },
    sym '@lsp.type.method' { sym '@method' },
    sym '@lsp.type.macro' { sym '@macro' },
    sym '@lsp.type.decorator' { sym '@function' },

    LazyButton { NormalFloat, sp = NormalFloat.fg, gui = 'bold' },
    LazyButtonActive { fg = ui_important_local.readable(), sp = NormalFloat.fg, bg = ui_important_local, gui = LazyButton
      .gui },
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
    NoicePopupmenuBorder { fg = ui_accent, bg = NormalFloat.bg },
    NoicePopupmenuMatch { Bold },
    NoicePopupmenuSelected { PmenuSel },

    NoiceScrollbar { PmenuSbar },
    NoiceScrollbarThumb { PmenuThumb },

    NoiceSplit { NormalFloat },
    NoiceSplitBorder { NoiceConfirmBorder, bg = NormalFloat.bg },
    NoiceVirtualText { fg = ui_important_local, bg = ui_backdrop, gui = 'bold' },
    NotifyERRORBorder { DiagnosticError, bg = NormalFloat.bg },
    NotifyWARNBorder { DiagnosticWarn, bg = NormalFloat.bg },
    NotifyINFOBorder { DiagnosticInfo, bg = NormalFloat.bg },
    NotifyDEBUGBorder { fg = Debug.bg, bg = NormalFloat.bg },
    NotifyTRACEBorder { DiagnosticHint, bg = NormalFloat.bg },

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

    FlashBackdrop {},
    FlashMatch { bg = content_unfocus },
    FlashCurrent { fg = content_accent, bg = content_unfocus },
    FlashLabel { fg = Search.bg, bg = Search.fg },

    GitSignsAdd { fg = DiffAdd.fg, bg = ui_backdrop },
    GitSignsChange { fg = DiffChange.fg, bg = ui_backdrop },
    GitSignsDelete { fg = DiffDelete.fg, bg = ui_backdrop },

    GitSignsChangedelete { GitSignsChange },
    GitSignsTopdelete { GitSignsDelete },
    GitSignsUntracked { GitSignsAdd },

    GitSignsAddNr { GitSignsAdd },
    GitSignsChangeNr { GitSignsChange },
    GitSignsDeleteNr { GitSignsDelete },

    GitSignsChangedeleteNr { GitSignsChange },
    GitSignsTopdeleteNr { GitSignsDelete },
    GitSignsUntrackedNr { GitSignsAdd },

    GitSignsAddLn { GitSignsAdd },
    GitSignsChangeLn { GitSignsChange },
    GitSignsChangedeleteLn { GitSignsChange },
    GitSignsUntrackedLn { GitSignsAdd },

    GitSignsAddPreview { GitSignsAdd },
    GitSignsDeletePreview { GitSignsDelete },

    GitSignsCurrentLineBlame { Debug },
    GitSignsAddInline { GitSignsAdd },
    GitSignsDeleteInline { GitSignsDelete },
    GitSignsChangeInline { GitSignsChange },

    GitSignsAddLnInline { DiffText },
    GitSignsDeleteLnInline { DiffText },
    GitSignsChangeLnInline { DiffText },

    GitSignsDeleteVirtLn { GitSignsDelete },
    GitSignsDeleteVirtLnInLine { DiffText },
    GitSignsVirtLnum { fg = LineNr.fg },

    WhichKey { fg = ui_important_global },
    WhichKeyGroup { fg = ui_important_local },
    WhichKeySeparator { fg = ui_minor },
    WhichKeyDesc { fg = ui_normal },
    WhichKeyFloat { NormalFloat },
    WhichKeyBorder { FloatBorder },
    WhichKeyValue { Comment },

    IblIndent { Whitespace },
    IblWhitespace { Whitespace },
    IblScope { fg = ui_focus, bg = content_backdrop },

    Hlargs { fg = ui_important_local },

    MiniStarterCurrent { fg = ui_accent.readable(), bg = ui_accent },  -- current item.
    MiniStarterFooter { Keyword },   -- footer units.
    MiniStarterHeader { Comment },   -- header units.
    MiniStarterInactive { fg = content_unfocus }, -- inactive item.
    MiniStarterItem { Normal },     -- item name.
    MiniStarterItemBullet { Whitespace }, -- units from |MiniStarter.gen_hook.adding_bullet|.
    MiniStarterItemPrefix { fg = content_focus, gui = '' }, -- unique query for item.
    MiniStarterSection { fg = content_important_global, gui = 'underline' },  -- section units.
    MiniStarterQuery { fg = content_accent.readable(), bg = content_accent },    -- current query in active items.
  }
end )

return nugu
