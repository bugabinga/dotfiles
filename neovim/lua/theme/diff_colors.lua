return function(Group, groups, colors, styles)
  Group.new('DiffAdd', colors.normal, colors.none, styles.NONE)
  Group.new('DiffChange', colors.normal, colors.none, styles.NONE)
  Group.new('DiffDelete', colors.normal, colors.none, styles.NONE)
  Group.new('DiffText', colors.normal, colors.none, styles.NONE)
end
