local palette = require 'bugabinga.nugu.palette'

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
vim.g.terminal_color_1 = error                    -- maroon
vim.g.terminal_color_2 = content_focus            -- green
vim.g.terminal_color_3 = warning                  -- olive
vim.g.terminal_color_4 = content_important_local  -- navy
vim.g.terminal_color_5 = content_important_global -- purple
vim.g.terminal_color_6 = info                     -- teal
vim.g.terminal_color_7 = content_minor            -- silver

vim.g.terminal_color_8 = content_unfocus          -- grey
vim.g.terminal_color_9 = error                    -- red
vim.g.terminal_color_10 = content_accent          -- lime
vim.g.terminal_color_11 = warning                 -- yellow
vim.g.terminal_color_12 = info                    -- blue
vim.g.terminal_color_13 = debug                   -- fuchsia
vim.g.terminal_color_14 = content_focus           -- aqua
vim.g.terminal_color_15 = content_normal          -- white

local set_group_properties = function ( self, properties )
  vim.validate {
    properties = { properties, 'table' },
    -- • fg (or foreground): color name or "#RRGGBB", see note.
    ['properties.fg'] = { properties.fg, 'string', true },
    -- • bg (or background): color name or "#RRGGBB", see note.
    ['properties.bg'] = { properties.bg, 'string', true },
    -- • sp (or special): color name or "#RRGGBB"
    ['properties.sp'] = { properties.sp, 'string', true },
    -- • blend: integer between 0 and 100
    ['properties.blend'] = { properties.blend, 'number', true },
    -- • bold: boolean
    ['properties.bold'] = { properties.bold, 'boolean', true },
    -- • standout: boolean
    ['properties.standout'] = { properties.standout, 'boolean', true },
    -- • underline: boolean
    ['properties.underline'] = { properties.underline, 'boolean', true },
    -- • undercurl: boolean
    ['properties.undercurl'] = { properties.undercurl, 'boolean', true },
    -- • underdotted: boolean
    ['properties.underdotted'] = { properties.underdotted, 'boolean', true },
    -- • underdashed: boolean
    ['properties.underdashed'] = { properties.underdashed, 'boolean', true },
    -- • strikethrough: boolean
    ['properties.strikethrough'] = { properties.strikethrough, 'boolean', true },
    -- • italic: boolean
    ['properties.italic'] = { properties.italic, 'boolean', true },
    -- • reverse: boolean
    ['properties.reverse'] = { properties.reverse, 'boolean', true },
    -- • nocombine: boolean
    ['properties.nocombine'] = { properties.nocombine, 'boolean', true },
    -- • default: Don't override existing definition |:hi-default|
    ['properties.default'] = { properties.default, 'boolean', true },
    -- • ctermfg: Sets foreground of cterm color |ctermfg|
    ['properties.ctermfg'] = { properties.ctermfg, 'string', true },
    -- • ctermbg: Sets background of cterm color |ctermbg|
    ['properties.ctermbg'] = { properties.ctermbg, 'string', true },
    -- • cterm: cterm attribute map, like |highlight-args|. If not set, cterm attributes will match those from the attribute map documented above.
    ['properties.cterm'] = { properties.cterm, 'table', true },
    -- • force: if true force update the highlight group when it exists.
    ['properties.force'] = { properties.force, 'boolean', true },
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
  for name, group_link in pairs( self.groups ) do
    if group_link == value then
      -- vim.print( 'found group to link ' .. name .. ' to ' .. key )
      group.link = name
      return group
    end
  end
end

local _ = setmetatable( { groups = {} }, {
  __index = add_group,
  __newindex = link_group,
} )

_.Debug { fg = ui_normal, bg = debug, bold = true }

_.Normal { fg = content_normal, bg = content_backdrop }
_.NormalUi { fg = ui_normal, bg = ui_backdrop }
_.Comment { fg = content_important_global }
_.NotifyBackground = _.NormalUi
_.LineNr { fg = ui_minor, bg = content_backdrop }
_.CursorLineNr { fg = ui_focus, bg = ui_backdrop }
_.Search { bg = content_unfocus }
_.IncSearch { fg = content_focus }
_.CurSearch { fg = content_important_global, bg = content_unfocus }
_.NormalFloat = _.NormalUi
_.FloatBorder { fg = ui_accent, bg = _.Normal.bg }
_.ColorColumn { fg = ui_important_global, bg = _.Normal.bg }
_.Conceal { fg = content_focus, bg = _.Normal.bg }
_.Cursor { fg = content_backdrop, bg = content_accent }
-- _.lCursor = _.Cursor
-- _.CursorIM = _.Cursor
_.Directory { fg = _.Normal.fg }
_.DiffAdd { fg = content_focus }
_.DiffDelete { fg = content_focus, strikethrough = true }
_.DiffChange { fg = content_important_global }
_.DiffText { fg = content_normal, bg = content_unfocus }
_.EndOfBuffer = _.Normal
-- _.TermCursor = _.Cursor
-- _.TermCursorNC = _.Cursor
_.ErrorMsg { fg = error }
_.VertSplit { fg = ui_important_global }
_.Folded = _.Conceal
_.FoldColumn = _.LineNr
_.SignColumn = _.LineNr
_.ModeMsg { bold = true }
_.MsgArea = _.NormalUi
_.MsgSeparator = _.NormalUi
_.MoreMsg = _.NormalUi
_.NonText { fg = content_unfocus }
_.Whitespace = _.NonText
_.NormalNC { fg = content_minor, bg = _.Normal.bg }
_.Pmenu = _.NormalFloat
_.PmenuSel { fg = ui_important_local, sp = ui_important_local, bg = _.Pmenu.bg, bold = true, underline = true }
_.PmenuSbar { bg = ui_unfocus }
_.PmenuThumb { bg = ui_minor }
_.Question { fg = ui_important_local, bold = true }
_.QuickFixLine = _.PmenuSel
_.SpecialKey { fg = error, bg = content_unfocus, bold = true }
_.SpellBad { fg = error, undercurl = true }
_.SpellCap = _.SpellBad
_.SpellLocal = _.SpellBad
_.SpellRare = _.SpellBad
_.StatusLine = _.NormalUi
_.StatusLineNC { fg = ui_minor, bg = ui_backdrop }
_.Winbar { fg = ui_focus, bg = _.StatusLine.bg }
_.WinbarNC { fg = content_minor, bg = _.Normal.bg }
_.Title { fg = content_important_global, sp = content_important_global, bold = true, underline = true }
_.TabLine = _.StatusLine
_.TabLineFill = _.StatusLine
_.TabLineSel { fg = ui_important_global, bold = true, underline = true }
_.Visual { bg = content_unfocus }
_.VisualNOS { bg = ui_unfocus }
_.WarningMsg { fg = warning, bold = true }
_.WildMenu = _.Debug
_.TextYankPost { fg = content_backdrop, bg = ui_important_local }

_.String { fg = content_important_local, italic = true }
_.Constant = _.String
_.Character = _.String
_.Number = _.String
_.Boolean = _.String
_.Float = _.String

_.Identifier = _.Normal
_.MutableVariable = _.Debug
_.Function = _.Normal

_.Statement { fg = content_minor }
_.Conditional = _.Statement
_.Repeat = _.Statement
_.Label = _.Statement
_.Operator = _.Statement
_.Keyword = _.Statement
_.Parameter { fg = content_focus }
_.Exception = _.Statement

_.PreProc { fg = content_important_global, bold = true }
_.Include = _.PreProc
_.Define = _.PreProc
_.Macro = _.PreProc
_.PreCondit = _.PreProc

_.Type = _.Normal
_.StorageClass = _.Statement
_.Structure = _.Statement
_.Typedef = _.Statement

_.Special { fg = content_normal, italic = true, bold = true }
_.SpecialChar = _.Special
_.Tag = _.Special
_.Delimiter { fg = content_minor }
_.SpecialComment = _.Special

_.Underlined { sp = content_normal, underline = true }
_.Bold { bold = true }
_.Italic { italic = true }

_.Ignore { fg = _.Normal.bg, bg = _.Normal.bg }

_.Error { fg = error }
_.Todo { fg = content_important_global, sp = content_important_global, bold = true, underdouble = true }
_.DiagnosticUnnecessary { fg = ui_focus }
_.DiagnosticDeprecated { fg = ui_important_global, sp = ui_important_global, strikethrough = true }
_.DiagnosticError { fg = error }
_.DiagnosticWarn { fg = warning }
_.DiagnosticInfo { fg = info }
_.DiagnosticHint { fg = ui_important_local }
_.DiagnosticOk { fg = ui_minor }

_.DiagnosticVirtualTextError = _.DiagnosticError
_.DiagnosticVirtualTextWarn = _.DiagnosticWarn
_.DiagnosticVirtualTextInfo = _.DiagnosticInfo
_.DiagnosticVirtualTextHint = _.DiagnosticHint
_.DiagnosticVirtualOkHint = _.DiagnosticOk
_.DiagnosticUnderlineError { fg = _.DiagnosticError.fg, sp = _.DiagnosticError.fg, underdouble = true }
_.DiagnosticUnderlineWarn { fg = _.DiagnosticWarn.fg, sp = _.DiagnosticWarn.fg, underline = true }
_.DiagnosticUnderlineInfo { fg = _.DiagnosticInfo.fg, sp = _.DiagnosticInfo.fg, underdashed = true }
_.DiagnosticUnderlineHint { fg = _.DiagnosticHint.fg, sp = _.DiagnosticHint.fg, italic = true, underdotted = true }
_.DiagnosticUnderlineOk { fg = _.DiagnosticOk.fg, italic = true }
_.DiagnosticSignError = _.DiagnosticError
_.DiagnosticSignWarn = _.DiagnosticWarn
_.DiagnosticSignInfo = _.DiagnosticInfo
_.DiagnosticSignHint = _.DiagnosticHint
_.DiagnosticSignOk = _.DiagnosticOk

_.LspReferenceText { sp = content_unfocus, underline = true }
_.LspReferenceRead = _.LspReferenceText
_.LspReferenceWrite = _.LspReferenceText
_.LspInlayHint { fg = content_minor, bg = _.Normal.bg }
_.LspSignatureActiveParameter = _.Debug

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
_['@attribute'] = _.Keyword
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
_['@keyword.return'] { fg = _.Keyword.fg, bg = _.Keyword.bg, underline = true, bold = true }
_['@exception'] = _.Exception
_['@variable'] = _.Identifier
_['@variable.parameter'] = _.Parameter
_['@type'] = _.Type
_['@type.builtin'] = _.Type
_['@type.definition'] = _.Typedef
_['@storageclass'] = _.StorageClass
_['@structure'] = _.Structure
_['@namespace'] = _.Italic
_['@include'] = _.Include
_['@preproc'] = _.PreProc
_['@debug'] = _.Debug
_['@tag'] = _.Tag

_['@markup.raw.block'] { bg = content_backdrop }
-- _['@markup.raw.block.markdown'] { fg = ui_normal, bg = ui_backdrop }
-- _['@markup.raw.block.vimdoc'] { fg = ui_normal, bg = ui_backdrop }

_['@lsp.type.namespace'] = _['@namespace']
_['@lsp.type.type'] = _['@type']
_['@lsp.type.modifier'] = _['@keyword']
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
_.LazyButton { sp = _.NormalFloat.fg, bold = true }
_.LazyButtonActive { fg = ui_focus, sp = _.NormalFloat.fg, bg = ui_important_local, bold = true }
_.LazyComment = _.Keyword
_.LazyCommit = _.LazyComment
_.LazyCommitIssue = _.LazyComment
_.LazyCommitScope = _.LazyComment
_.LazyCommitScope { italic = true }
_.LazyCommitType = _.LazyCommitScope
_.LazyDimmed { fg = _.NormalFloat.fg }
_.LazyDir { fg = _.NormalFloat.fg }
_.LazyH1 = _.Bold
_.LazyH2 = _.LazyH1
_.LazyLocal {}
_.LazyNoCond = _.WarningMsg
_.LazyNormal = _.NormalFloat
_.LazyProgressDone { fg = _.Search.bg, bg = _.Cursor.bg, bold = true }
_.LazyProgressTodo { fg = _.LazyProgressDone.bg, bg = _.LazyProgressDone.fg, bold = true }
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
_.LazySpecial { fg = _.ColorColumn.fg }
_.LazyTaskError = _.ErrorMsg
_.LazyTaskOutput = _.Debug
_.LazyUrl { sp = _.NormalFloat.fg, italic = true, underline = true }
_.LazyValue { italic = true }

_.TelescopeSelectionCaret = _.PmenuSel
_.TelescopeSelection = _.PmenuSel
_.TelescopeMultiSelection { fg = content_normal, bg = ui_important_local }

_.FlashBackdrop { fg = ui_normal, bg = ui_backdrop }
_.FlashMatch = _.IncSearch
_.FlashCurrent = _.CurSearch
_.FlashLabel { fg = ui_accent, bg = ui_backdrop }

_.WhichKey { fg = ui_important_global }
_.WhichKeyGroup { fg = ui_important_local }
_.WhichKeySeparator { fg = ui_minor }
_.WhichKeyDesc { fg = ui_normal }
_.WhichKeyFloat = _.NormalFloat
_.WhichKeyBorder = _.FloatBorder
_.WhichKeyValue = _.Comment

return function ()
  local namespace = 0
  for name, group in pairs( _.groups ) do
    vim.api.nvim_set_hl( namespace, name, group )
  end
end
