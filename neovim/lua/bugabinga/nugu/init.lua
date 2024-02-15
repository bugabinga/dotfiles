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
local content_unfocus = flux( hsl( palette.content_unfocus ), 21 ) -- FIXME: this change needs to go into nugu
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
    Comment { fg = content_important_global },
    LineNr { fg = ui_minor, bg = content_backdrop },
    CursorLineNr { fg = ui_focus, bg = ui_backdrop },
    Search { fg = content_important_global, bg = content_important_global.readable() },
    IncSearch { fg = content_important_local, bg = content_important_local.readable() },
    NormalFloat { fg = ui_normal, bg = ui_backdrop },
    FloatBorder { fg = NormalFloat.bg, bg = NormalFloat.bg },
    ColorColumn { fg = ui_important_global, bg = Normal.bg },
    Conceal { fg = content_focus, bg = Normal.bg },
    Cursor { bg = ui_accent },
    -- lCursor { Cursor },
    -- CursorIM { Cursor },
    Directory { fg = Normal.fg },
    DiffAdd { fg = content_focus },
    DiffDelete { fg = content_focus, gui = 'strikethrough' },
    DiffChange { fg = content_important_global },
    DiffText { fg = content_important_local.readable(), bg = content_important_local },
    EndOfBuffer { Normal },
    -- TermCursor { Cursor },
    -- TermCursorNC { Cursor },
    ErrorMsg { fg = error.readable(), bg = error },
    VertSplit { fg = ui_important_global, bg = LineNr.bg },
    Folded { Conceal },
    FoldColumn { LineNr },
    SignColumn { LineNr },
    ModeMsg { gui = 'bold' },
    MsgArea { Normal },
    MsgSeparator { Debug },
    MoreMsg { Normal },
    NonText { fg = content_unfocus },
    Whitespace { NonText },
    NormalNC { Normal },
    Pmenu { NormalFloat },
    PmenuSel { fg = ui_important_local, sp = ui_important_local, bg = Pemnu.bg, gui = 'bold underline' },
    PmenuSbar { bg = ui_unfocus },
    PmenuThumb { bg = ui_minor },
    Question { fg = ui_important_local, gui = 'bold' },
    QuickFixLine { PmenuSel },
    SpecialKey { fg = error, bg = content_unfocus, gui = 'bold' },
    SpellBad { fg = error, gui = 'undercurl' },
    SpellCap { SpellBad },
    SpellLocal { SpellBad },
    SpellRare { SpellBad },
    StatusLine { fg = ui_focus, bg = ui_unfocus },
    StatusLineNC { fg = ui_normal, bg = ui_unfocus },
    Winbar { fg = ui_focus, bg = StatusLine.bg },
    WinbarNC { fg = ui_minor, bg = LineNr.bg },
    Title { fg = content_important_global, sp = content_important_global, gui = 'bold underline' },
    TabLine { StatusLine },
    TabLineFill { fg = TabLine.fg, bg = content_backdrop },
    TabLineSel { fg = ui_important_global, bg = ui_unfocus },
    Visual { fg = content_focus.readable(), bg = content_focus },
    VisualNOS { fg = Visual.fg, bg = flux( Visual.bg, -42 ) },
    WarningMsg { fg = warning, gui = 'bold' },
    WildMenu { Debug },

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
    LspInlayHint { fg = content_minor, bg = Normal.bg },

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
    LazyReasonCmd { NormalFloat },
    LazyReasonEvent { NormalFloat },
    LazyReasonFt { NormalFloat },
    LazyReasonImport { NormalFloat },
    LazyReasonKeys { NormalFloat },
    LazyReasonPlugin { NormalFloat },
    LazyReasonRuntime { NormalFloat },
    LazyReasonSource { NormalFloat },
    LazyReasonStart { NormalFloat },
    LazySpecial { fg = ColorColumn.fg },
    LazyTaskError { ErrorMsg },
    LazyTaskOutput { Debug },
    LazyUrl { sp = NormalFloat.fg, gui = 'italic underline' },
    LazyValue { gui = 'italic' },

    NoiceCmdline { NormalFloat },
    NoiceCmdlineIcon { fg = ui_accent },
    NoiceCmdlineIconCalculator { NoiceCmdlineIcon },
    NoiceCmdlineIconCmdline { NoiceCmdlineIcon },
    NoiceCmdlineIconFilter { NoiceCmdlineIcon },
    NoiceCmdlineIconHelp { NoiceCmdlineIcon },
    NoiceCmdlineIconIncRename { NoiceCmdlineIcon },
    NoiceCmdlineIconInput { NoiceCmdlineIcon },
    NoiceCmdlineIconLua { NoiceCmdlineIcon },
    NoiceCmdlineIconSearch { NoiceCmdlineIcon },

    NoiceCmdlinePopup { NormalFloat },
    NoiceCmdlinePopupBorder { FloatBorder },
    NoiceCmdlinePopupBorderCalculator { NoiceCmdlinePopupBorder },
    NoiceCmdlinePopupBorderCmdline { NoiceCmdlinePopupBorder },
    NoiceCmdlinePopupBorderFilter { NoiceCmdlinePopupBorder },
    NoiceCmdlinePopupBorderHelp { NoiceCmdlinePopupBorder },
    NoiceCmdlinePopupBorderIncRename { NoiceCmdlinePopupBorder },
    NoiceCmdlinePopupBorderInput { NoiceCmdlinePopupBorder },
    NoiceCmdlinePopupBorderLua { NoiceCmdlinePopupBorder },
    NoiceCmdlinePopupBorderSearch { NoiceCmdlinePopupBorder },
    NoiceCmdlinePopupTitle { NoiceCmdlinePopup },
    NoiceCmdlinePrompt { NoiceCmdlinePopup },
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
    NoiceConfirmBorder { FloatBorder },
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
    NoicePopupBorder { FloatBorder },

    NoicePopupmenu { Pmenu },
    NoicePopupmenuBorder { FloatBorder },
    NoicePopupmenuMatch { Bold },
    NoicePopupmenuSelected { PmenuSel },

    NoiceScrollbar { PmenuSbar },
    NoiceScrollbarThumb { PmenuThumb },

    NoiceSplit { Normal },
    NoiceSplitBorder { FloatBorder },
    NoiceVirtualText { fg = ui_important_global, bg = ui_unfocus },
    NotifyERRORBorder { fg = DiagnosticError.fg, bg = FloatBorder.bg },
    NotifyWARNBorder { fg = DiagnosticWarn.fg, bg = FloatBorder.bg },
    NotifyINFOBorder { fg = DiagnosticInfo.fg, bg = FloatBorder.bg },
    NotifyDEBUGBorder { fg = Debug.bg, bg = FloatBorder.bg },
    NotifyTRACEBorder { fg = DiagnosticHint.fg, bg = FloatBorder.bg },

    NotifyERRORIcon { fg = DiagnosticError.fg },
    NotifyWARNIcon { fg = DiagnosticWarn.fg },
    NotifyINFOIcon { fg = DiagnosticInfo.fg },
    NotifyDEBUGIcon { fg = Debug.bg },
    NotifyTRACEIcon { fg = DiagnosticHint.fg },

    NotifyERRORTitle { fg = DiagnosticError.fg },
    NotifyWARNTitle { fg = DiagnosticWarn.fg },
    NotifyINFOTitle { fg = DiagnosticInfo.fg },
    NotifyDEBUGTitle { fg = Debug.bg },
    NotifyTRACETitle { fg = DiagnosticHint.fg },

    NotifyERRORBody { NormalFloat },
    NotifyWARNBody { NormalFloat },
    NotifyINFOBody { NormalFloat },
    NotifyDEBUGBody { NormalFloat },
    NotifyTRACEBody { NormalFloat },

    TelescopeSelectionCaret { PmenuSel },
    TelescopeSelection { PmenuSel },
    TelescopeMultiSelection { fg = ui_important_local.readable(), bg = ui_important_local },

    FlashBackdrop {},
    FlashMatch { fg = Search.bg },
    FlashCurrent { fg = IncSearch.bg },
    FlashLabel { Search },

    GitSignsAdd { fg = DiffAdd.fg, bg = LineNr.bg },
    GitSignsChange { fg = DiffChange.fg, bg = LineNr.bg },
    GitSignsDelete { fg = DiffDelete.fg, bg = LineNr.bg },

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

    GitSignsCurrentLineBlame { NonText },
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
    IblScope { fg = ui_focus, bg = Normal.bg },

    Hlargs { fg = content_important_local },
    MiniStarterCurrent { fg = ui_accent.readable(), bg = ui_accent },         -- current item.
    MiniStarterFooter { Keyword },                                            -- footer units.
    MiniStarterHeader { Comment },                                            -- header units.
    MiniStarterInactive { fg = content_unfocus },                             -- inactive item.
    MiniStarterItem { Normal },                                               -- item name.
    MiniStarterItemBullet { Whitespace },                                     -- units from |MiniStarter.gen_hook.adding_bullet|.
    MiniStarterItemPrefix { fg = content_focus, gui = '' },                   -- unique query for item.
    MiniStarterSection { fg = content_important_global, gui = 'underline' },  -- section units.
    MiniStarterQuery { fg = content_accent.readable(), bg = content_accent }, -- current query in active items.
  }
end )

return nugu
