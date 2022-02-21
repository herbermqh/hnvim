
-- Setup Telescope
require('telescope').setup({
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    find_command = {
      'rg', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'
    },
    layout_config = {
      width = 0.75,
      prompt_position = "bottom",
      preview_cutoff = 120,
      horizontal = {mirror = false},
      vertical = {mirror = false}
    },
    initial_mode = 'insert',
    prompt_prefix = " ",
    selection_caret = " ",
    entry_prefix = "  ",
    file_ignore_patterns = { '.git/*', 'node_modules', 'env/*' },
    selection_strategy = "reset",
    use_less = true,
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
    color_devicons = true,
    winblend = 20,
    path_display = {},
    border = {},
    borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    }
  }
})
-- Load Telescope extensions
require('telescope').load_extension('fzy_native')



