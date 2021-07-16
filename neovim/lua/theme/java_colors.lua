return function(Group, groups, colors, styles)
  Group.new('javaParen', colors.normal, colors.none, no)
  Group.new('javaOperator', colors.normal, colors.none, no)
  Group.new('javaVarArg', colors.normal, colors.none, no)
  Group.new('javaParen1', colors.normal, colors.none, no)
  Group.new('javaParen2', colors.normal, colors.none, no)
  Group.new('javaParen3', colors.normal, colors.none, no)
  Group.new('javaParen4', colors.normal, colors.none, no)
  Group.new('javaParen5', colors.normal, colors.none, no)
  Group.new('javaAnnotation', colors.normal, colors.none, no)
  Group.new('javaDocTags', colors.normal, colors.none, no)
  Group.new(
    'javaCommentTitle',
    colors.important,
    colors.none,
    styles.bold + styles.underline
  )
end
