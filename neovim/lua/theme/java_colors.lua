return function(Group, _groups, colors, styles)
  Group.new('javaOperator', colors.normal, colors.none, styles.NONE)
  Group.new('javaVarArg', colors.normal, colors.none, styles.NONE)
  Group.new('javaParen', colors.normal, colors.none, styles.NONE)
  Group.new('javaParen1', colors.normal, colors.none, styles.NONE)
  Group.new('javaParen2', colors.normal, colors.none, styles.NONE)
  Group.new('javaParen3', colors.normal, colors.none, styles.NONE)
  Group.new('javaParen4', colors.normal, colors.none, styles.NONE)
  Group.new('javaParen5', colors.normal, colors.none, styles.NONE)
  Group.new('javaAnnotation', colors.normal, colors.none, styles.NONE)
  Group.new('javaDocTags', colors.normal, colors.none, styles.NONE)
  Group.new(
    'javaCommentTitle',
    colors.important,
    colors.none,
    styles.bold + styles.underline
  )
end
