require'nvim-tree'.setup {
  disable_netrw        = false,
  hijack_netrw         = true,
  open_on_setup        = false,
  ignore_ft_on_setup   = {},
  auto_close           = false,
  auto_reload_on_write = true,
  open_on_tab          = false,
  hijack_cursor        = false,
  update_cwd           = false,
  hijack_unnamed_buffer_when_opening = true,
  hijack_directories   = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = true,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'right',
    auto_resize = true,
    mappings = {
      custom_only = true,
      list = {
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
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  },
  actions = {
    change_dir = {
      global = false,
    },
    open_file = {
      quit_on_open = false,
    }
  }
}


