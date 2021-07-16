return function(Group, groups, colors, styles)
  Group.new('TSFloat', groups.Float, groups.Float, groups.Float)
  Group.new('TSFunction', groups.Function, groups.Function, groups.Function)
  Group.new('TSType', groups.Type, groups.Type, groups.Type)
  Group.new('TSTypeBuiltin', groups.Type, groups.Type, groups.Type)
  Group.new('TSLabel', groups.Label, groups.Label, groups.Label)
  Group.new('TSCharacter', groups.Character, groups.Character, groups.Character)
  Group.new(
    'TSConditional',
    groups.Conditional,
    groups.Conditional,
    groups.Conditional
  )
  Group.new('TSConstant', groups.Constant, groups.Constant, groups.Constant)
  Group.new('TSConstBuiltin', groups.Constant, groups.Constant, groups.Constant)
  Group.new('TSConstMacro', groups.Constant, groups.Constant, groups.Constant)
  Group.new('TSFuncBuiltin', groups.Function, groups.Function, groups.Function)
  Group.new('TSMethod', groups.Function, groups.Function, groups.Function)
  Group.new('TSStructure', groups.Structure, groups.Structure, groups.Structure)
  Group.new(
    'TSTagDelimiter',
    groups.Delimiter,
    groups.Delimiter,
    groups.Delimiter
  )
  Group.new('TSNumber', groups.Number, groups.Number, groups.Number)
  Group.new('TSFuncMacro', groups.Function, groups.Function, groups.Function)
  Group.new('TSInclude', groups.Include, groups.Include, groups.Include)
  Group.new('TSKeyword', groups.Keyword, groups.Keyword, groups.Keyword)
  Group.new('TSException', groups.Exception, groups.Exception, groups.Exception)
  Group.new('TSBoolean', groups.Boolean, groups.Boolean, groups.Boolean)
  Group.new('TSError', groups.Error, groups.Error, groups.Error)
  Group.new('TSString', groups.String, groups.String, groups.String)
  Group.new('TSStringEscape', colors.normal, colors.none, styles.NONE)
  Group.new('TSStringRegex', colors.normal, colors.none, styles.NONE)
  Group.new('TSField', colors.normal, colors.none, styles.NONE)
  Group.new('TSParameter', colors.normal, colors.none, styles.NONE)
  Group.new('TSVariable', colors.normal, colors.none, styles.bold)
  Group.new('TSPunctBracket', colors.normal, colors.none, styles.NONE)
  Group.new('TSOperator', colors.normal, colors.none, styles.NONE)
  Group.new('TSProperty', colors.normal, colors.none, styles.NONE)
end
