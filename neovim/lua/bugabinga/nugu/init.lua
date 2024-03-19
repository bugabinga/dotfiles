local palette = require 'bugabinga.nugu.palette'
local preview = require 'bugabinga.nugu.preview'

local debug = (palette.debug)
local error = (palette.error)
local info = (palette.info)
local warning = (palette.warning)

local content_normal = palette.content_normal
local content_backdrop = palette.content_backdrop
local content_accent = palette.content_accent
local content_minor = palette.content_minor
local content_focus = palette.content_focus
local content_unfocus = palette.content_unfocus
local content_important_global = palette.content_important_global
local content_important_local = palette.content_important_local

local ui_normal = palette.ui_normal
local ui_backdrop = palette.ui_backdrop
local ui_accent = palette.ui_accent
local ui_minor = palette.ui_minor
local ui_focus = palette.ui_focus
local ui_unfocus = palette.ui_unfocus
local ui_important_global = palette.ui_important_global
local ui_important_local = palette.ui_important_local

vim.g.terminal_color_0 = ui_backdrop              -- black
vim.g.terminal_color_1 = content_accent           -- maroon
vim.g.terminal_color_2 = info                     -- green
vim.g.terminal_color_3 = ui_focus                 -- olive
vim.g.terminal_color_4 = content_important_local  -- navy
vim.g.terminal_color_5 = content_important_global -- purple
vim.g.terminal_color_6 = ui_focus                 -- teal
vim.g.terminal_color_7 = content_normal           -- silver

vim.g.terminal_color_8 = ui_minor                 -- grey
vim.g.terminal_color_9 = error                    -- red
vim.g.terminal_color_10 = info                    -- lime
vim.g.terminal_color_11 = content_focus           -- yellow
vim.g.terminal_color_12 = ui_important_local      -- blue
vim.g.terminal_color_13 = ui_accent               -- fuchsia
vim.g.terminal_color_14 = ui_important_global     -- aqua
vim.g.terminal_color_15 = ui_normal               -- white

local set_group_properties = function ( self, properties )
  vim.validate {
    properties = { properties, 'table', },
    -- • fg (or foreground): color name or "#RRGGBB", see note.
    ['properties.fg'] = { properties.fg, 'string', true, },
    -- • bg (or background): color name or "#RRGGBB", see note.
    ['properties.bg'] = { properties.bg, 'string', true, },
    -- • sp (or special): color name or "#RRGGBB"
    ['properties.sp'] = { properties.sp, 'string', true, },
    -- • blend: integer between 0 and 100
    ['properties.blend'] = { properties.blend, 'number', true, },
    -- • bold: boolean
    ['properties.bold'] = { properties.bold, 'boolean', true, },
    -- • standout: boolean
    ['properties.standout'] = { properties.standout, 'boolean', true, },
    -- • underline: boolean
    ['properties.underline'] = { properties.underline, 'boolean', true, },
    -- • undercurl: boolean
    ['properties.undercurl'] = { properties.undercurl, 'boolean', true, },
    -- • underdotted: boolean
    ['properties.underdotted'] = { properties.underdotted, 'boolean', true, },
    -- • underdashed: boolean
    ['properties.underdashed'] = { properties.underdashed, 'boolean', true, },
    -- • strikethrough: boolean
    ['properties.strikethrough'] = { properties.strikethrough, 'boolean', true, },
    -- • italic: boolean
    ['properties.italic'] = { properties.italic, 'boolean', true, },
    -- • reverse: boolean
    ['properties.reverse'] = { properties.reverse, 'boolean', true, },
    -- • nocombine: boolean
    ['properties.nocombine'] = { properties.nocombine, 'boolean', true, },
    -- • default: Don't override existing definition |:hi-default|
    ['properties.default'] = { properties.default, 'boolean', true, },
    -- • ctermfg: Sets foreground of cterm color |ctermfg|
    ['properties.ctermfg'] = { properties.ctermfg, 'string', true, },
    -- • ctermbg: Sets background of cterm color |ctermbg|
    ['properties.ctermbg'] = { properties.ctermbg, 'string', true, },
    -- • cterm: cterm attribute map, like |highlight-args|. If not set, cterm attributes will match those from the attribute map documented above.
    ['properties.cterm'] = { properties.cterm, 'table', true, },
    -- • force: if true force update the highlight group when it exists.
    ['properties.force'] = { properties.force, 'boolean', true, },
  }
  -- vim.print( 'SET GROUP PROPERTIES', self, properties )
  for key, value in pairs( properties ) do
    self[key] = value
  end
end

local new_group = function ()
  return setmetatable( {}, {
    __call = set_group_properties,
  } )
end

local add_group = function ( self, key )
  if not self.groups[key] then
    self.groups[key] = new_group()
  end
  return self.groups[key]
end

local link_group = function ( self, key, value )
  -- vim.print( 'linking group', self, key, value )
  local group = add_group( self, key )
  for name, link_group in pairs( self.groups ) do
    if link_group == value then
      -- vim.print( 'found group to link ' .. name .. ' to ' .. key )
      group.link = name
      return group
    end
  end
end

local _ = setmetatable( { groups = {}, }, {
  __index = add_group,
  __newindex = link_group,
} )

_.Debug { fg = ui_normal, bg = debug, bold = true, }
_.Normal { fg = content_normal, bg = content_backdrop, }
_.NotifyBackground { bg = ui_backdrop, }
_.Comment { fg = content_important_global, }
_.LineNr { fg = ui_minor, bg = content_backdrop, }
_.CursorLineNr { fg = ui_focus, bg = ui_backdrop, }
_.Search { bg = content_unfocus, }
_.IncSearch { fg = content_focus, }
_.CurSearch { fg = content_normal, bg = content_important_global, }
_.NormalFloat { fg = ui_normal, bg = ui_backdrop, }
_.FloatBorder { fg = _.NormalFloat.bg, bg = _.NormalFloat.bg, }
_.ColorColumn { fg = ui_important_global, bg = _.Normal.bg, }
_.Conceal { fg = content_focus, bg = _.Normal.bg, }
_.Cursor { bg = ui_accent, }
-- _.lCursor = _.Cursor
-- _.CursorIM = _.Cursor
_.Directory { fg = _.Normal.fg, }
_.DiffAdd { fg = content_focus, }
_.DiffDelete { fg = content_focus, strikethrough = true, }
_.DiffChange { fg = content_important_global, }
_.DiffText { fg = content_normal, bg = content_important_local, }
_.EndOfBuffer = _.Normal
-- _.TermCursor = _.Cursor
-- _.TermCursorNC = _.Cursor
_.ErrorMsg { fg = error, }
_.VertSplit { fg = ui_important_global, bg = _.LineNr.bg, }
_.Folded = _.Conceal
_.FoldColumn = _.LineNr
_.SignColumn = _.LineNr
_.ModeMsg { bold = true, }
_.MsgArea = _.Normal
_.MsgSeparator = _.Debug
_.MoreMsg = _.Normal
_.NonText { fg = content_unfocus, }
_.Whitespace = _.NonText
_.NormalNC = _.Normal
_.Pmenu = _.NormalFloat
_.PmenuSel { fg = ui_important_local, sp = ui_important_local, bg = _.Pmenu.bg, bold = true, underline = true, }
_.PmenuSbar { bg = ui_unfocus, }
_.PmenuThumb { bg = ui_minor, }
_.Question { fg = ui_important_local, bold = true, }
_.QuickFixLine = _.PmenuSel
_.SpecialKey { fg = error, bg = content_unfocus, bold = true, }
_.SpellBad { fg = error, undercurl = true, }
_.SpellCap = _.SpellBad
_.SpellLocal = _.SpellBad
_.SpellRare = _.SpellBad
_.StatusLine { fg = ui_focus, bg = ui_unfocus, }
_.StatusLineNC { fg = ui_normal, bg = ui_unfocus, }
_.Winbar { fg = ui_focus, bg = _.StatusLine.bg, }
_.WinbarNC { fg = ui_minor, bg = _.LineNr.bg, }
_.Title { fg = content_important_global, sp = content_important_global, bold = true, underline = true, }
_.TabLine = _.StatusLine
_.TabLineFill { fg = _.TabLine.fg, bg = content_backdrop, }
_.TabLineSel { fg = ui_important_global, bg = ui_unfocus, }
_.Visual { bg = content_unfocus, }
_.VisualNOS { bg = ui_unfocus, }
_.WarningMsg { fg = warning, bold = true, }
_.WildMenu = _.Debug

_.String { fg = content_important_local, italic = true, }
_.Constant = _.String
_.Character = _.String
_.Number = _.String
_.Boolean = _.String
_.Float = _.String

_.Identifier = _.Normal
_.MutableVariable = _.Debug
_.Function = _.Normal

_.Statement { fg = content_minor, }
_.Conditional = _.Statement
_.Repeat = _.Statement
_.Label = _.Statement
_.Operator = _.Statement
_.Keyword = _.Statement
_.Exception = _.Statement

_.PreProc { fg = content_important_global, bg = content_unfocus, bold = true, }
_.Include = _.PreProc
_.Define = _.PreProc
_.Macro = _.PreProc
_.PreCondit = _.PreProc
_.Parameter { fg = content_focus, }

_.Type = _.Statement
_.StorageClass = _.Statement
_.Structure = _.Statement
_.Typedef = _.Statement

_.Special { fg = content_normal, italic = true, bold = true, }
_.SpecialChar = _.Special
_.Tag = _.Special
_.Delimiter { fg = content_minor, }
_.SpecialComment = _.Special

_.Underlined { sp = content_normal, underline = true, }
_.Bold { bold = true, }
_.Italic { italic = true, }

_.Ignore { fg = _.Normal.bg, bg = _.Normal.bg, }

_.Error { fg = error, }
_.Todo { fg = content_important_global, sp = content_important_global, bold = true, underdouble = true, }
_.DiagnosticUnnecessary { fg = ui_focus, }
_.DiagnosticDeprecated { fg = ui_important_global, sp = ui_important_global, strikethrough = true, }
_.DiagnosticError { fg = error, }
_.DiagnosticWarn { fg = warning, }
_.DiagnosticInfo { fg = info, }
_.DiagnosticHint { fg = ui_important_local, }
_.DiagnosticOk { fg = ui_minor, }

_.DiagnosticVirtualTextError = _.DiagnosticError
_.DiagnosticVirtualTextWarn = _.DiagnosticWarn
_.DiagnosticVirtualTextInfo = _.DiagnosticInfo
_.DiagnosticVirtualTextHint = _.DiagnosticHint
_.DiagnosticVirtualOkHint = _.DiagnosticOk
_.DiagnosticUnderlineError { fg = _.DiagnosticError.fg, sp = _.DiagnosticError.fg, underdouble = true, }
_.DiagnosticUnderlineWarn { fg = _.DiagnosticWarn.fg, sp = _.DiagnosticWarn.fg, underline = true, }
_.DiagnosticUnderlineInfo { fg = _.DiagnosticInfo.fg, sp = _.DiagnosticInfo.fg, underdashed = true, }
_.DiagnosticUnderlineHint { fg = _.DiagnosticHint.fg, sp = _.DiagnosticHint.fg, italic = true, underdotted = true, }
_.DiagnosticUnderlineOk { fg = _.DiagnosticOk.fg, italic = true, }
_.DiagnosticSignError = _.DiagnosticError
_.DiagnosticSignWarn = _.DiagnosticWarn
_.DiagnosticSignInfo = _.DiagnosticInfo
_.DiagnosticSignHint = _.DiagnosticHint
_.DiagnosticSignOk = _.DiagnosticOk

_.LspReferenceText { sp = content_unfocus, underline = true, }
_.LspReferenceRead = _.LspReferenceText
_.LspReferenceWrite = _.LspReferenceText
_.LspInlayHint { fg = content_minor, bg = _.Normal.bg, }

_['@text.literal'] = _.Comment
_['@text.reference'] = _.Identifier
_['@text.title'] = _.Title
_['@text.underline'] = _.Underlined
_['@text.todo'] = _.Todo
_['@comment'] = _.Comment
_['@punctuation'] = _.Delimiter
_['@constant'] = _.Constant
_['@constant.builtin'] = _.Special
_['@constant.macro'] = _.Define
_['@define'] = _.Define
_['@macro'] = _.Macro
_['@string'] = _.String
_['@string.escape'] = _.SpecialChar
_['@string.special'] = _.SpecialChar
_['@character'] = _.Character
_['@character.special'] = _.SpecialChar
_['@number'] = _.Number
_['@boolean'] = _.Boolean
_['@float'] = _.Float
_['@function'] = _.Function
_['@function.builtin'] = _.Special
_['@function.macro'] = _.Macro
_['@parameter'] = _.Parameter
_['@method'] = _.Function
_['@field'] = _.Identifier
_['@property'] = _.Identifier
_['@constructor'] = _.Special
_['@conditional'] = _.Conditional
_['@repeat'] = _.Repeat
_['@label'] = _.Label
_['@operator'] = _.Operator
_['@keyword'] = _.Keyword
_['@keyword.return'] { fg = _.Keyword.fg, bg = _.Keyword.bg, underline = true, bold = true, }
_['@exception'] = _.Exception
_['@variable'] = _.Identifier
_['@type'] = _.Type
_['@type.definition'] = _.Typedef
_['@storageclass'] = _.StorageClass
_['@structure'] = _.Structure
_['@namespace'] = _.PreProc
_['@include'] = _.Include
_['@preproc'] = _.PreProc
_['@debug'] = _.Debug
_['@tag'] = _.Tag

_['@lsp.type.namespace'] = _['@namespace']
_['@lsp.type.type'] = _['@type']
_['@lsp.type.class'] = _['@type']
_['@lsp.type.enum'] = _['@type']
_['@lsp.type.interface'] = _['@type']
_['@lsp.type.struct'] = _['@structure']
_['@lsp.type.parameter'] = _['@parameter']
_['@lsp.type.variable'] = _['@variable']
_['@lsp.type.property'] = _['@property']
_['@lsp.type.enumMember'] = _['@constant']
_['@lsp.type.function'] = _['@function']
_['@lsp.type.method'] = _['@method']
_['@lsp.type.macro'] = _['@macro']
_['@lsp.type.decorator'] = _['@function']

_.LazyButton = _.NormalFloat
_.LazyButton { sp = _.NormalFloat.fg, bold = true, }
_.LazyButtonActive { fg = ui_focus, sp = _.NormalFloat.fg, bg = ui_important_local, bold = true, }
_.LazyComment = _.Keyword
_.LazyCommit = _.LazyComment
_.LazyCommitIssue = _.LazyComment
_.LazyCommitScope = _.LazyComment
_.LazyCommitScope { italic = true, }
_.LazyCommitType = _.LazyCommitScope
_.LazyDimmed { fg = _.NormalFloat.fg, }
_.LazyDir { fg = _.NormalFloat.fg, }
_.LazyH1 = _.Bold
_.LazyH2 = _.LazyH1
_.LazyLocal {}
_.LazyNoCond = _.WarningMsg
_.LazyNormal = _.NormalFloat
_.LazyProgressDone { fg = _.Search.bg, bg = _.Cursor.bg, bold = true, }
_.LazyProgressTodo { fg = _.LazyProgressDone.bg, bg = _.LazyProgressDone.fg, bold = true, }
_.LazyProp = _.LazyComment
_.LazyReasonCmd = _.NormalFloat
_.LazyReasonEvent = _.NormalFloat
_.LazyReasonFt = _.NormalFloat
_.LazyReasonImport = _.NormalFloat
_.LazyReasonKeys = _.NormalFloat
_.LazyReasonPlugin = _.NormalFloat
_.LazyReasonRuntime = _.NormalFloat
_.LazyReasonSource = _.NormalFloat
_.LazyReasonStart = _.NormalFloat
_.LazySpecial { fg = _.ColorColumn.fg, }
_.LazyTaskError = _.ErrorMsg
_.LazyTaskOutput = _.Debug
_.LazyUrl { sp = _.NormalFloat.fg, italic = true, underline = true, }
_.LazyValue { italic = true, }

-- _.NoiceCmdline = _.NormalFloat
-- _.NoiceCmdlineIcon { fg = ui_accent, }
-- _.NoiceCmdlineIconCalculator = _.NoiceCmdlineIcon
-- _.NoiceCmdlineIconCmdline = _.NoiceCmdlineIcon
-- _.NoiceCmdlineIconFilter = _.NoiceCmdlineIcon
-- _.NoiceCmdlineIconHelp = _.NoiceCmdlineIcon
-- _.NoiceCmdlineIconIncRename = _.NoiceCmdlineIcon
-- _.NoiceCmdlineIconInput = _.NoiceCmdlineIcon
-- _.NoiceCmdlineIconLua = _.NoiceCmdlineIcon
-- _.NoiceCmdlineIconSearch = _.NoiceCmdlineIcon
--
-- _.NoiceCmdlinePopup = _.NormalFloat
-- _.NoiceCmdlinePopupBorder = _.FloatBorder
-- _.NoiceCmdlinePopupBorderCalculator = _.NoiceCmdlinePopupBorder
-- _.NoiceCmdlinePopupBorderCmdline = _.NoiceCmdlinePopupBorder
-- _.NoiceCmdlinePopupBorderFilter = _.NoiceCmdlinePopupBorder
-- _.NoiceCmdlinePopupBorderHelp = _.NoiceCmdlinePopupBorder
-- _.NoiceCmdlinePopupBorderIncRename = _.NoiceCmdlinePopupBorder
-- _.NoiceCmdlinePopupBorderInput = _.NoiceCmdlinePopupBorder
-- _.NoiceCmdlinePopupBorderLua = _.NoiceCmdlinePopupBorder
-- _.NoiceCmdlinePopupBorderSearch = _.NoiceCmdlinePopupBorder
-- _.NoiceCmdlinePopupTitle = _.NoiceCmdlinePopup
-- _.NoiceCmdlinePrompt = _.NoiceCmdlinePopup
-- _.NoiceCompletionItemKindDefault { fg = ui_normal, }
-- _.NoiceCompletionItemKindClass = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindColor = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindConstant = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindConstructor = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindEnum = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindEnumMember = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindField = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindFile = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindFolder = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindFunction = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindInterface = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindKeyword = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindMethod = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindModule = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindProperty = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindSnippet = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindStruct = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindText = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindUnit = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindValue = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemKindVariable = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemMenu = _.NoiceCompletionItemKindDefault
-- _.NoiceCompletionItemWord = _.NoiceCompletionItemKindDefault
--
-- _.NoiceConfirm = _.NormalFloat
-- _.NoiceConfirmBorder = _.FloatBorder
-- _.NoiceFormatConfirm = _.LazyButton
-- _.NoiceFormatConfirmDefault = _.LazyButtonActive
--
-- _.NoiceCursor = _.Cursor
--
-- _.NoiceFormatDate = _.NonText
-- _.NoiceFormatEvent = _.NonText
-- _.NoiceFormatKind = _.NonText
-- _.NoiceFormatLevelDebug { fg = _.Debug.bg, }
-- _.NoiceFormatLevelError = _.DiagnosticError
-- _.NoiceFormatLevelInfo = _.DiagnosticInfo
-- _.NoiceFormatLevelOff { fg = content_minor, }
-- _.NoiceFormatLevelTrace = _.DiagnosticHint
-- _.NoiceFormatLevelWarn = _.DiagnosticWarn
-- _.NoiceFormatProgressDone = _.LazyProgressDone
-- _.NoiceFormatProgressTodo = _.LazyProgressTodo
-- _.NoiceFormatTitle = _.Title
--
-- _.NoiceLspProgressClient = _.Debug
-- _.NoiceLspProgressSpinner = _.Debug
-- _.NoiceLspProgressTitle = _.Debug
--
-- _.NoiceMini = _.DiagnosticInfo
--
-- _.NoicePopup = _.NormalFloat
-- _.NoicePopupBorder = _.FloatBorder
--
-- _.NoicePopupmenu = _.Pmenu
-- _.NoicePopupmenuBorder = _.FloatBorder
-- _.NoicePopupmenuMatch = _.Bold
-- _.NoicePopupmenuSelected = _.PmenuSel
--
-- _.NoiceScrollbar = _.PmenuSbar
-- _.NoiceScrollbarThumb = _.PmenuThumb
--
-- _.NoiceSplit = _.Normal
-- _.NoiceSplitBorder = _.FloatBorder
-- _.NoiceVirtualText { fg = ui_important_global, bg = ui_unfocus, }
-- _.NotifyERRORBorder { fg = _.DiagnosticError.fg, bg = _.FloatBorder.bg, }
-- _.NotifyWARNBorder { fg = _.DiagnosticWarn.fg, bg = _.FloatBorder.bg, }
-- _.NotifyINFOBorder { fg = _.DiagnosticInfo.fg, bg = _.FloatBorder.bg, }
-- _.NotifyDEBUGBorder { fg = _.Debug.bg, bg = _.FloatBorder.bg, }
-- _.NotifyTRACEBorder { fg = _.DiagnosticHint.fg, bg = _.FloatBorder.bg, }
--
-- _.NotifyERRORIcon { fg = _.DiagnosticError.fg, }
-- _.NotifyWARNIcon { fg = _.DiagnosticWarn.fg, }
-- _.NotifyINFOIcon { fg = _.DiagnosticInfo.fg, }
-- _.NotifyDEBUGIcon { fg = _.Debug.bg, }
-- _.NotifyTRACEIcon { fg = _.DiagnosticHint.fg, }
--
-- _.NotifyERRORTitle { fg = _.DiagnosticError.fg, }
-- _.NotifyWARNTitle { fg = _.DiagnosticWarn.fg, }
-- _.NotifyINFOTitle { fg = _.DiagnosticInfo.fg, }
-- _.NotifyDEBUGTitle { fg = _.Debug.bg, }
-- _.NotifyTRACETitle { fg = _.DiagnosticHint.fg, }
--
-- _.NotifyERRORBody = _.NormalFloat
-- _.NotifyWARNBody = _.NormalFloat
-- _.NotifyINFOBody = _.NormalFloat
-- _.NotifyDEBUGBody = _.NormalFloat
-- _.NotifyTRACEBody = _.NormalFloat

_.TelescopeSelectionCaret = _.PmenuSel
_.TelescopeSelection = _.PmenuSel
_.TelescopeMultiSelection { fg = content_normal, bg = ui_important_local, }

_.FlashBackdrop {}
_.FlashMatch = _.IncSearch
_.FlashCurrent = _.CurSearch
_.FlashLabel { fg = ui_accent, bg = ui_backdrop, }

_.GitSignsAdd { fg = _.DiffAdd.fg, bg = _.LineNr.bg, }
_.GitSignsChange { fg = _.DiffChange.fg, bg = _.LineNr.bg, }
_.GitSignsDelete { fg = _.DiffDelete.fg, bg = _.LineNr.bg, }

_.GitSignsChangedelete = _.GitSignsChange
_.GitSignsTopdelete = _.GitSignsDelete
_.GitSignsUntracked = _.GitSignsAdd

_.GitSignsAddNr = _.GitSignsAdd
_.GitSignsChangeNr = _.GitSignsChange
_.GitSignsDeleteNr = _.GitSignsDelete

_.GitSignsChangedeleteNr = _.GitSignsChange
_.GitSignsTopdeleteNr = _.GitSignsDelete
_.GitSignsUntrackedNr = _.GitSignsAdd

_.GitSignsAddLn = _.GitSignsAdd
_.GitSignsChangeLn = _.GitSignsChange
_.GitSignsChangedeleteLn = _.GitSignsChange
_.GitSignsUntrackedLn = _.GitSignsAdd

_.GitSignsAddPreview = _.GitSignsAdd
_.GitSignsDeletePreview = _.GitSignsDelete

_.GitSignsCurrentLineBlame = _.NonText
_.GitSignsAddInline = _.GitSignsAdd
_.GitSignsDeleteInline = _.GitSignsDelete
_.GitSignsChangeInline = _.GitSignsChange

_.GitSignsAddLnInline = _.DiffText
_.GitSignsDeleteLnInline = _.DiffText
_.GitSignsChangeLnInline = _.DiffText

_.GitSignsDeleteVirtLn = _.GitSignsDelete
_.GitSignsDeleteVirtLnInLine = _.DiffText
_.GitSignsVirtLnum { fg = _.LineNr.fg, }

_.WhichKey { fg = ui_important_global, }
_.WhichKeyGroup { fg = ui_important_local, }
_.WhichKeySeparator { fg = ui_minor, }
_.WhichKeyDesc { fg = ui_normal, }
_.WhichKeyFloat = _.NormalFloat
_.WhichKeyBorder = _.FloatBorder
_.WhichKeyValue = _.Comment

_.IblIndent = _.Whitespace
_.IblWhitespace = _.Whitespace
_.IblScope { fg = ui_focus, bg = _.Normal.bg, }


_.MiniStarterCurrent { fg = ui_normal, bg = ui_accent, }
_.MiniStarterFooter = _.Keyword
_.MiniStarterHeader = _.Comment
_.MiniStarterInactive { fg = content_unfocus, }
_.MiniStarterItem = _.Normal
_.MiniStarterItemBullet = _.Whitespace
_.MiniStarterItemPrefix { fg = content_focus, }
_.MiniStarterSection { fg = content_important_global, underline = true, }
_.MiniStarterQuery { fg = content_normal, bg = content_accent, }

--TODO: Oil highlights

return function ()
  preview.setup()
  local namespace = 0
  for name, group in pairs( _.groups ) do
    vim.api.nvim_set_hl( namespace, name, group )
  end
end
