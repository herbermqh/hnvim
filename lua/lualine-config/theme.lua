local colors = {
  black        = '#000000',
  white        = 'guifg',
  red          = '#e57373',
  green        = '#81c784',
  blue         = '#7986cb',
  yellow       = '#fff176',
  gray         = '#e57373',
  orange       = '#ffb74d',
  magenta      = '#ba68c8',
  grey         = '#303030',
  background   = 'guibg',
  darkgray     = 'guibg',
  lightgray    = 'guibg',
  inactivegray = 'guibg',
}
return {
  normal = {
    a = {bg = colors.green, fg = colors.black, gui = 'bold'},
    b = {bg = colors.grey, fg = colors.white},
    c = {bg = colors.background, fg = colors.green}
  },
  insert = {
    a = {bg = colors.blue, fg = colors.black, gui = 'bold'},
    b = {bg = colors.grey, fg = colors.white},
    c = {bg = colors.background, fg = colors.blue}
  },
  visual = {
    a = {bg = colors.magenta, fg = colors.black, gui = 'bold'},
    b = {bg = colors.grey, fg = colors.white},
    c = {bg = colors.background, fg = colors.magenta}
  },
  replace = {
    a = {bg = colors.red, fg = colors.black, gui = 'bold'},
    b = {bg = colors.grey, fg = colors.white},
    c = {bg = colors.black, fg = colors.white}
  },
  command = {
    a = {bg = colors.orange, fg = colors.black, gui = 'bold'},
    b = {bg = colors.grey, fg = colors.white},
    c = {bg = colors.background, fg = colors.orange}
  },
  inactive = {
    a = {bg = colors.background, fg = colors.blue, gui = 'bold'},
    b = {bg = colors.background, fg = colors.blue},
    c = {bg = colors.background, fg = colors.blue}
  }
}
