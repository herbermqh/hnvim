-- listkeys = {
--   { key = {"<CR>", "o", "<2-LeftMouse>", "<Right>"},  action = "edit"},
--   { key = "<C-v>",                                    action = "vsplit"},
--   { key = "<C-x>",                                    action = "split"},
--   { key = "<C-t>",                                    action = "tabnew"},
--   { key = "<",                                        action = "prev_sibling"},
--   { key = ">",                                        action = "next_sibling"},
--   { key = "P",                                        action = "parent_node"},
--   { key = "<BS>",                                     action = "close_node"},
--   { key = "<S-CR>",                                   action = "close_node"},
--   { key = "<Left>",                                   action = "close_node"}, --Heber
--   { key = "<Tab>",                                    action = "preview"},
--   { key = "K",                                        action = "first_sibling"},
--   { key = "J",                                        action = "last_sibling"},
--   { key = "I",                                        action = "toggle_ignored"},
--   { key = "H",                                        action = "toggle_dotfiles"},
--   { key = "R",                                        action = "refresh"},
--   { key = "m",                                        action = "create"},
--   { key = "d",                                        action = "remove"},
--   { key = "a",                                        action = "rename"}, --Heber
--   { key = "<C-r>",                                    action = "full_rename"},
--   { key = "dd",                                       action = "cut"}, --
--   { key = "yy",                                       action = "copy"}, --Heber
--   { key = "pp",                                       action = "paste"}, --Heber
--   { key = "yn",                                       action = "copy_name"}, --Heber
--   { key = "yd",                                       action = "copy_path"}, --Heber
--   { key = "gy",                                       action = "copy_absolute_path"},
--   { key = "[c",                                       action = "prev_git_item"},
--   { key = "]c",                                       action = "next_git_item"},
--   { key = "-",                                        action = "dir_up"},
--   { key = "s",                                        action = "system_open"},
--   { key = "q",                                        action = "close"},
--   { key = "g?",                                       action = "toggle_help"  },
-- }

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  -- custom mappings
  vim.keymap.set('n', '<C-]>',   api.tree.change_root_to_node,        opts('CD'))
  vim.keymap.set('n', '<C-e>',   api.node.open.replace_tree_buffer,   opts('Open: In Place'))
  vim.keymap.set('n', '<C-k>',   api.node.show_info_popup,            opts('Info'))
  vim.keymap.set('n', '<C-r>',   api.fs.rename_sub,                   opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-t>',   api.node.open.tab,                   opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>',   api.node.open.vertical,              opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>',   api.node.open.horizontal,            opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<BS>',    api.node.navigate.parent_close,      opts('Close Directory'))
  vim.keymap.set('n', '<CR>',    api.node.open.edit,                  opts('Open'))
  vim.keymap.set('n', '<Tab>',   api.node.open.preview,               opts('Open Preview'))
  vim.keymap.set('n', '>',       api.node.navigate.sibling.next,      opts('Next Sibling'))
  vim.keymap.set('n', '<',       api.node.navigate.sibling.prev,      opts('Previous Sibling'))
  vim.keymap.set('n', '.',       api.node.run.cmd,                    opts('Run Command'))
  vim.keymap.set('n', '-',       api.tree.change_root_to_parent,      opts('Up'))
  vim.keymap.set('n', 'a',       api.fs.create,                       opts('Create File Or Directory'))
  vim.keymap.set('n', 'bd',      api.marks.bulk.delete,               opts('Delete Bookmarked'))
  vim.keymap.set('n', 'bt',      api.marks.bulk.trash,                opts('Trash Bookmarked'))
  vim.keymap.set('n', 'bmv',     api.marks.bulk.move,                 opts('Move Bookmarked'))
  vim.keymap.set('n', 'B',       api.tree.toggle_no_buffer_filter,    opts('Toggle Filter: No Buffer'))
  vim.keymap.set('n', 'c',       api.fs.copy.node,                    opts('Copy'))
  vim.keymap.set('n', 'C',       api.tree.toggle_git_clean_filter,    opts('Toggle Filter: Git Clean'))
  vim.keymap.set('n', '[c',      api.node.navigate.git.prev,          opts('Prev Git'))
  vim.keymap.set('n', ']c',      api.node.navigate.git.next,          opts('Next Git'))
  vim.keymap.set('n', 'd',       api.fs.remove,                       opts('Delete'))
  vim.keymap.set('n', 'D',       api.fs.trash,                        opts('Trash'))
  vim.keymap.set('n', 'E',       api.tree.expand_all,                 opts('Expand All'))
  vim.keymap.set('n', 'e',       api.fs.rename_basename,              opts('Rename: Basename'))
  vim.keymap.set('n', ']e',      api.node.navigate.diagnostics.next,  opts('Next Diagnostic'))
  vim.keymap.set('n', '[e',      api.node.navigate.diagnostics.prev,  opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F',       api.live_filter.clear,               opts('Live Filter: Clear'))
  vim.keymap.set('n', 'f',       api.live_filter.start,               opts('Live Filter: Start'))
  vim.keymap.set('n', 'g?',      api.tree.toggle_help,                opts('Help'))
  vim.keymap.set('n', 'gy',      api.fs.copy.absolute_path,           opts('Copy Absolute Path'))
  vim.keymap.set('n', 'H',       api.tree.toggle_hidden_filter,       opts('Toggle Filter: Dotfiles'))
  vim.keymap.set('n', 'I',       api.tree.toggle_gitignore_filter,    opts('Toggle Filter: Git Ignore'))
  vim.keymap.set('n', 'J',       api.node.navigate.sibling.last,      opts('Last Sibling'))
  vim.keymap.set('n', 'K',       api.node.navigate.sibling.first,     opts('First Sibling'))
  vim.keymap.set('n', 'L',       api.node.open.toggle_group_empty,    opts('Toggle Group Empty'))
  vim.keymap.set('n', 'M',       api.tree.toggle_no_bookmark_filter,  opts('Toggle Filter: No Bookmark'))
  -- vim.keymap.set('n', 'm',       api.marks.toggle,                    opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o',       api.node.open.edit,                  opts('Open'))
  vim.keymap.set('n', 'O',       api.node.open.no_window_picker,      opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p',       api.fs.paste,                        opts('Paste'))
  vim.keymap.set('n', 'P',       api.node.navigate.parent,            opts('Parent Directory'))
  vim.keymap.set('n', 'q',       api.tree.close,                      opts('Close'))
  vim.keymap.set('n', 'r',       api.fs.rename,                       opts('Rename'))
  vim.keymap.set('n', 'R',       api.tree.reload,                     opts('Refresh'))
  vim.keymap.set('n', 's',       api.node.run.system,                 opts('Run System'))
  vim.keymap.set('n', 'S',       api.tree.search_node,                opts('Search'))
  vim.keymap.set('n', 'u',       api.fs.rename_full,                  opts('Rename: Full Path'))
  vim.keymap.set('n', 'U',       api.tree.toggle_custom_filter,       opts('Toggle Filter: Hidden'))
  vim.keymap.set('n', 'W',       api.tree.collapse_all,               opts('Collapse'))
  vim.keymap.set('n', 'x',       api.fs.cut,                          opts('Cut'))
  vim.keymap.set('n', 'y',       api.fs.copy.filename,                opts('Copy Name'))
  vim.keymap.set('n', 'Y',       api.fs.copy.relative_path,           opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- mis key de listkeys de nommbre Heber
--   { key = "<Left>",                                   action = "close_node"}, --Heber
--   { key = "a",                                        action = "rename"}, --Heber
--   { key = "yy",                                       action = "copy"}, --Heber
--   { key = "pp",                                       action = "paste"}, --Heber
--   { key = "yn",                                       action = "copy_name"}, --Heber
--   { key = "yd",                                       action = "copy_path"}, --Heber
--   { key = {"<CR>", "o", "<2-LeftMouse>", "<Right>"},  action = "edit"},
--   { key = "m",                                        action = "create"},
  vim.keymap.set('n', '<Left>',  api.node.navigate.parent_close,      opts('Close Directory'))
  vim.keymap.set('n', 'a',       api.fs.rename_basename,              opts('Rename: Basename'))
  vim.keymap.set('n', 'yy',      api.fs.copy.node,                    opts('Copy'))
  vim.keymap.set('n', 'pp',      api.fs.paste,                        opts('Paste'))
  vim.keymap.set('n', 'yn',      api.fs.copy.filename,                opts('Copy Name'))
  vim.keymap.set('n', 'yd',      api.fs.copy.relative_path,           opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', 'o',       api.node.open.edit,                  opts('Open'))
  vim.keymap.set('n', '<Right>', api.node.open.edit,                  opts('Open'))
  vim.keymap.set('n', 'm',       api.fs.create,                       opts('Create File Or Directory'))
  --
end
require'nvim-tree'.setup {
  auto_reload_on_write = true,
  disable_netrw        = false,
  hijack_cursor        = true,
  hijack_netrw         = true,
  hijack_unnamed_buffer_when_opening = true,
  -- ignore_buffer_on_setup = false,
  -- open_on_setup        = true,
  -- open_on_tab          = true,
  sort_by              = "case_sensitive",
  update_cwd           = true,
  view = {
    width = 30,
    -- height = 30,
    side = "left",
    preserve_window_proportions = true,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    -- mappings = {
    --   custom_only = false,
    --   list = listkeys,
    -- },
  },
  on_attach = my_on_attach,
  renderer = {
    group_empty = true
  },
  hijack_directories = {
    enable    = true,
    auto_open = true,
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = true,
    ignore_list = {}
  },
  -- ignore_ft_on_setup = {},
  system_open = {
    cmd  = nil,
    args = {},
  },
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype  = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      git = false,
    },
  },
}

