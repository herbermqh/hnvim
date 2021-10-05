local vim = vim
local gl = require('galaxyline')
local utils = require('utils')

local gls = gl.section
gl.short_line_list = { 'defx', 'packager', 'vista' }

-- Colors
local colors = {
  bg = 'guibg',
  fg = 'guifg',
  section_bg = '#790e8b',
  yellow = '#ffff8b',
  cyan = '#6ff9ff',
  green = '#80e27e',
  orange = '#ffd95b',
  magenta = '#ff94c2',
  blue = '#80d6ff',
  red = '#ef5350'
}

-- Local helper functions
local buffer_not_empty = function()
  return not utils.is_buffer_empty()
end

local in_git_repo = function ()
  local vcs = require('galaxyline.provider_vcs')
  local branch_name = vcs.get_git_branch()

  return branch_name ~= nil
end

local checkwidth = function()
  return utils.has_width_gt(40) and in_git_repo()
end

local mode_color = function()
  local mode_colors = {
    n = colors.cyan,
    i = colors.green,
    c = colors.orange,
    V = colors.magenta,
    [''] = colors.magenta,
    v = colors.magenta,
    R = colors.red,
  }

  local color = mode_colors[vim.fn.mode()]

  if color == nil then
    color = colors.red
  end

  return color
end

-- Left side
gls.left[1] = {
  FirstElement = {
    provider = function() return '▋' end,
    highlight = { colors.cyan}
  },
}
gls.left[2] = {
  ViMode = {
    provider = function()
      local alias = {
        n = '  􎉵  ',
        i = '  􎉰  ',
        c = '  􎉦  ',
        V = '  􎊂  ',
        [''] = '  􎊂  ',
        v = '  􎊂  ',
        R = '  􎉺  ',
      }
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color())
      local alias_mode = alias[vim.fn.mode()]
      if alias_mode == nil then
        alias_mode = vim.fn.mode()
      end
      return alias_mode..''
    end,
    highlight = { colors.bg, colors.bg },
    separator = '▋',
    separator_highlight = {colors.cyan, colors.bg},
  },
}
gls.left[3] = {
  Space = {
    provider = function () return ' 'end,
    highlight = {colors.bg, colors.bg},
  }
}
gls.left[4] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.bg},
  },
}
gls.left[5] = {
  icon = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.bg},
  }
}
gls.left[6] = {
  FileName = {
    provider = 'FileName',
    condition = buffer_not_empty,
    highlight = { colors.blue, colors.section_bg },
    separator = "",
    separator_highlight = {colors.section_bg, colors.bg},
  }
}
gls.left[7] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = in_git_repo,
    highlight = {colors.orange,colors.bf},
  }
}
gls.left[8] = {
  GitBranch = {
    provider = function()
      local vcs = require('galaxyline.provider_vcs')
      local branch_name = vcs.get_git_branch()
      if (string.len(branch_name) > 28) then
        return string.sub(branch_name, 1, 25).."..."
      end
      return branch_name .. " "
    end,
    condition = in_git_repo,
    highlight = {colors.fg,colors.bg},
  }
}
gls.left[9] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = ' ',
    highlight = { colors.green, colors.bg },
  }
}
gls.left[10] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = ' ',
    highlight = { colors.orange, colors.bg },
  }
}
gls.left[11] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = ' ',
    highlight = { colors.red,colors.bg },
  }
}
gls.left[12] = {
  LeftEnd = {
    provider = function() return ' ▋ ' end,
    condition = buffer_not_empty,
    highlight = {colors.section_bg,colors.bg}
  }
}
gls.left[13] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.bg}
  }
}
gls.left[14] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.bg,colors.bg},
  }
}
gls.left[15] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.orange,colors.bf},
  }
}
gls.left[16] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.bg,colors.bg},
  }
}
gls.left[17] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue,colors.bg},
    separator = ' ',
    separator_highlight = { colors.section_bg, colors.bg },
  }
}
-- Right side
gls.right[1]= {
  FileFormat = {
    provider = function() return vim.bo.filetype end,
    highlight = { colors.blue,colors.section_bg },
    separator = '',
    separator_highlight = { colors.section_bg,colors.bg },
  }
}
gls.right[2] = {
  LineInfo = {
    provider = 'LineColumn',
    highlight = { colors.blue, colors.section_bg },
    separator = '▋',
    separator_highlight = { colors.section_bg, colors.fg},
  },
}
-- gls.right[3] = {
--   Heart = {
--     provider = function() return ' ' end,
--     highlight = { colors.red, colors.section_bg },
--     separator = ' | ',
--     separator_highlight = { colors.bg, colors.section_bg },
--   }
-- }

-- Short status line
gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    highlight = { colors.fg, colors.section_bg },
    separator = '▋',
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = { colors.yellow, colors.section_bg },
    separator = '▋',
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
