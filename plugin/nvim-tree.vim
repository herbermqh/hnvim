" let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
" let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
" let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
" let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
" let g:nvim_tree_show_icons = {
"       \ 'git': 1,
"       \ 'folders': 1,
"       \ 'files': 1,
"       \ 'folder_arrows': 1,
"       \ }
" let g:nvim_tree_icons = {
"       \ 'default': '',
"       \ 'symlink': '',
"       \ 'git': {
"         \   'unstaged': "✗",
"         \   'staged': "✓",
"         \   'unmerged': "",
"         \   'renamed': "➜",
"         \   'untracked': "★",
"         \   'deleted': "",
"         \   'ignored': "◌"
"         \   },
"         \ 'folder': {
"           \   'arrow_open': "",
"           \   'arrow_closed': "",
"           \   'default': "",
"           \   'open': "",
"           \   'empty': "",
"           \   'empty_open': "",
"           \   'symlink': "",
"           \   'symlink_open': "",
"           \   }
"           \ }
set termguicolors " this variable must be enabled for colors to be applied properly
