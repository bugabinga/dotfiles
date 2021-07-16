return function(Color, colors, Group, groups, styles)
  -- TODO: manage background light and dark
  --
  -- let us first create some colors, that will later be mapped to highlight groups
  -- these will be saved in the `colors` table
  Color.new('important', '#e0e0e0')
  Color.new('normal', '#adadad')
  Color.new('minor', '#7c7c7c')
  Color.new('nonessential', '#4f4f4f')

  Color.new('error', '#e080a8')
  Color.new('warning', '#e0d996')
  Color.new('information', '#69cde0')

  Color.new('accent_strong', '#cfa1e6')
  Color.new('accent_weak', '#574461')

  Color.new('ui_normal', '#5e5e5e')
  Color.new('ui_important', '#78aba9')
  Color.new('ui_minor', '#547877')

  --intentionally ugly and easy to spot color, so that i can find out where it is used
  Color.new('debug', '#f111e1')

  require 'theme.terminal_colors'(Group, groups, colors, styles)
  require 'theme.nvim_editor_colors'(Group, groups, colors, styles)
  require 'theme.lsp_colors'(Group, groups, colors, styles)
  require 'theme.treesitter_colors'(Group, groups, colors, styles)
  require 'theme.java_colors'(Group, groups, colors, styles)
  require 'theme.lua_colors'(Group, groups, colors, styles)
  require 'theme.nvim_tree_colors'(Group, groups, colors, styles)
  require 'theme.diff_colors'(Group, groups, colors, styles)
end
