--[[ require('bufferline').setup{
  options = {
    indicator_icon = '▎',
    buffer_close_icon = '',
    modified_icon = '',
    close_icon = '',
    close_command = 'Bdelete %d',
    right_mouse_command = 'Bdelete! %d',
    left_trunc_marker = '',
    right_trunc_marker = '',
    offsets = {
      { filetype = 'NvimTree', text = 'EXPLORER', text_align = 'center' },
    },
    show_buffer_icons = true, -- disable filetype icons for buffers
    show_buffer_close_icons = true,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    enforce_regular_tabs = true,
    always_show_bufferline = true,
  },
} ]]
