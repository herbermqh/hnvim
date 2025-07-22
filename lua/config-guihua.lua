  --
  require('guihua.maps').setup({
    maps = {
      close_view = '<C-e>',
      send_qf = '<C-q>',
      save = '<C-s>',
      jump_to_list = '<C-w>k',
      jump_to_preview = '<C-w>j',
      prev = '<C-p>',
      next = '<C-n>',
      pageup = '<C-b>',
      pagedown = '<C-f>',
      confirm = '<C-o>',
      split = '<C-s>',
      vsplit = '<C-v>',
      tabnew = '<C-t>',
    },
    panel_icons = {
      section_separator = '─', --'',
      line_num_left = ':', --'',
      line_num_right = '', --',

      range_left = '', --'',
      range_right = '',
      inner_node = '', --├○',
      folded = '◉',
      unfolded = '○',

      outer_node = '', -- '╰○',
      bracket_left = '', -- ⟪',
      bracket_right = '', -- '⟫',
    },
    syntax_icons = {
      var = ' ', -- "👹", -- Vampaire
        method = 'ƒ ', --  "🍔", -- mac
        ['function'] = ' ', -- "🤣", -- Fun
        ['arrow_function'] = ' ', -- "🤣", -- Fun
          parameter = '', -- Pi
            associated = '🤝',
      namespace = '🚀',
      type = ' ',
      field = '🏈',
      interface = '',
      module = '📦',
      flag = '🎏',
    }
  })
