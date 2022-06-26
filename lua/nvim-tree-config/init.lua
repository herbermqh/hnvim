listkeys = {
  { key = {"<CR>", "o", "<2-LeftMouse>", "<Right>"},  action = "edit"},
  { key = "<C-v>",                                    action = "vsplit"},
  { key = "<C-x>",                                    action = "split"},
  { key = "<C-t>",                                    action = "tabnew"},
  { key = "<",                                        action = "prev_sibling"},
  { key = ">",                                        action = "next_sibling"},
  { key = "P",                                        action = "parent_node"},
  { key = "<BS>",                                     action = "close_node"},
  { key = "<S-CR>",                                   action = "close_node"},
  { key = "<Left>",                                   action = "close_node"}, --Heber
  { key = "<Tab>",                                    action = "preview"},
  { key = "K",                                        action = "first_sibling"},
  { key = "J",                                        action = "last_sibling"},
  { key = "I",                                        action = "toggle_ignored"},
  { key = "H",                                        action = "toggle_dotfiles"},
  { key = "R",                                        action = "refresh"},
  { key = "m",                                        action = "create"},
  { key = "d",                                        action = "remove"},
  { key = "a",                                        action = "rename"}, --Heber
  { key = "<C-r>",                                    action = "full_rename"},
  { key = "dd",                                       action = "cut"}, --
  { key = "yy",                                       action = "copy"}, --Heber
  { key = "pp",                                       action = "paste"}, --Heber
  { key = "yn",                                       action = "copy_name"}, --Heber
  { key = "yd",                                       action = "copy_path"}, --Heber
  { key = "gy",                                       action = "copy_absolute_path"},
  { key = "[c",                                       action = "prev_git_item"},
  { key = "]c",                                       action = "next_git_item"},
  { key = "-",                                        action = "dir_up"},
  { key = "s",                                        action = "system_open"},
  { key = "q",                                        action = "close"},
  { key = "g?",                                       action = "toggle_help"  },
}
require'nvim-tree'.setup {
  auto_reload_on_write = true,
  disable_netrw        = false,
  hijack_cursor        = true,
  hijack_netrw         = true,
  hijack_unnamed_buffer_when_opening = true,
  ignore_buffer_on_setup = false,
  open_on_setup        = true,
  open_on_tab          = true,
  sort_by              = "name",
  update_cwd           = true,
  view = {
    width = 30,
    height = 30,
    side = "right",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = listkeys,
    },
  },
  hijack_directories   = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  ignore_ft_on_setup = {},
  system_open = {
    cmd = nil,
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
          buftype = { "nofile", "terminal", "help" },
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



